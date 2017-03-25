var User = require('../models/user');
var userValidator = require('../validation/user');
var express = require('express');
var router = express.Router();

router.route('/')
    .post(function(req, res) {
        req.checkBody(userValidator);
        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }

            var user = new User(req.body);
            user.save(function(err, user) {
                if (err) {
                    return res.json(500, err);
                }

                res.json(201, {"_id": user._id});
            })
        });
    })
    .get(function(req, res) {
        User.find({}, function(err, users) {
            if (err) {
                return res.json(500, err);
            }

            res.json(200, users);
        });
    })

router.route('/login')
    .post(function(req, res) {
        req.checkQuery('fbUserId', 'Facebook User Id Required').notEmpty();

        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }

            var query = {};
            User.findOne({
                userId: req.query.fbUserId
            }, function(err, user) {
                if (err) {
                    return res.json(500, err);
                } else if (user != null) {
                    return res.json(200, user);
                } else {
                    var user = new User({
                        userId: req.query.fbUserId,
                        radius: 5000
                    });
                    user.save(function(err, user) {
                        if (err) {
                            return res.json(500, err);
                        }

                        res.json(201, user);
                    });
                }
            });
        });
    })

router.route('/:id')
    .get(function(req, res) {
        User.findOne({
            _id: req.params.id
        }, function(err, user) {
            if (err) {
                return res.json(500, err);
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            res.json(200, user);
        })
    })
    .put(function(req, res) {
        req.checkBody(userValidator);

        req.sanitizeBody('radius').toInt();

        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }

            User.findOne({
                _id : req.params.id
            }, function(err, user) {
                if (err) {
                    return res.json(500, err);
                } else if (user == null) {
                    return res.json(404, {"message": "User Not Found"});
                }

                user.radius = req.body.radius;
                user.save();

                res.json(200, {"message": "User updated successfully"});
            });
        });
    })
    .delete(function(req, res) {
        User.remove({
            _id: req.params.id
        }, function(err, user) {
            if (err) {
                return res.json(500, err);
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            res.json(200, {});
        })
    })

router.route('/:id/liked')
    .post(function(req, res) {
        req.checkQuery('eventId').isMongoId();
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, user) {
            if (err) {
                return res.json(500, err)
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = user.liked.indexOf(eventId)
            if (index >= 0) {
                res.json(403, {"message": "User has already liked this event"})
            } else {
                user.liked.push(eventId);
                if (user.viewed.indexOf(eventId) < 0) {
                    user.viewed.push(eventId);
                }
                user.save();

                res.json(200, {"message": "Event liked"});
            }
        })
    })
    .delete(function(req, res) {
        req.checkQuery('eventId').isMongoId();
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, user) {
            if (err) {
                return res.json(500, err)
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = user.liked.indexOf(eventId)
            if (index < 0) {
                res.json(403, {"message": "User has not liked this event"})
            } else {
                user.liked.splice(index, 1);
                user.save();

                res.json(200, {"message": "Event unliked"});
            }
        })
    })
    .get(function(req, res) {
        User.findOne({
            _id : req.params.id
        })
        .populate({
            path: 'liked',
            match: { startDate: { $gte: new Date() } }
        })
        .exec(function(err, user) {
            if (err) {
                return res.json(500, err);
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"});
            }

            var events = user.liked.sort((x,y) => {
                if (x.startDate < y.startDate) return -1;
                if (x.startDate > y.startDate) return 1;
                return 0;
            });

            res.json(200, events);
        })
    })

router.route('/:id/viewed')
    .post(function(req, res) {
        req.checkQuery('eventId').isMongoId();
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, user) {
            if (err) {
                return res.json(500, err)
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = user.liked.indexOf(eventId)
            if (index >= 0) {
                res.json(403, {"message": "User has already viewed this event"})
            } else {
                user.viewed.push(eventId);
                user.save();

                res.json(200, {"message": "Event viewed"});
            }
        })
    })
    .delete(function(req, res) {
        req.checkQuery('eventId').isMongoId();
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, user) {
            if (err) {
                return res.json(500, err)
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = user.viewed.indexOf(eventId)
            if (index < 0) {
                res.json(403, {"message": "User has not viewed this event"})
            } else {
                var index2 = user.liked.indexOf(eventId)
                if (index2 < 0) {
                    user.liked.splice(index2, 1);
                }
                user.viewed.splice(index, 1);
                user.save();

                res.json(200, {"message": "Event unviewed"});
            }
        })
    })
    .get(function(req, res) {
        User.findOne({
            _id : req.params.id
        })
        .populate({
            path: 'viewed',
            match: { startDate: { $gte: new Date() } }
        })
        .exec(function(err, user) {
            if (err) {
                return res.json(500, err);
            } else if (user == null) {
                return res.json(404, {"message": "User Not Found"});
            }

            var events = user.viewed.sort((x,y) => {
                if (x.startDate < y.startDate) return -1;
                if (x.startDate > y.startDate) return 1;
                return 0;
            });

            res.json(200, events);
        })
    })

module.exports = router;
