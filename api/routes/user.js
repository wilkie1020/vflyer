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
        });

        var user = new User(req.body);
        user.save(function(err, data) {
            if (err) {
                return res.json(500, err);
            }

            res.json(201, {"_id": data._id});
        })
    })
    .get(function(req, res) {
        User.find({}, function(err, data) {
            if (err) {
                return res.json(500, err);
            }

            res.json(200, data);
        });
    })

router.route('/:id')
    .get(function(req, res) {
        User.findOne({
            _id: req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err);
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            res.json(200, data);
        })
    })
    .delete(function(req, res) {
        User.remove({
            _id: req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err);
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            res.json(200, {});
        })
    })

router.route('/:id/liked')
    .post(function(req, res) {
        if (!req.query.eventId) {
            return res.json(400, {"message": "EventId required"})
        }
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err)
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = data.liked.indexOf(eventId)
            if (index >= 0) {
                res.json(403, {"message": "User has already liked this event"})
            } else {
                data.liked.push(eventId);
                if (data.viewed.indexOf(eventId) < 0) {
                    data.viewed.push(eventId);
                }
                data.save();

                res.json(200, {"message": "Event liked"});
            }
        })
    })
    .delete(function(req, res) {
        if (!req.query.eventId) {
            return res.json(400, {"message": "EventId required"})
        }
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err)
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = data.liked.indexOf(eventId)
            if (index < 0) {
                res.json(403, {"message": "User has not liked this event"})
            } else {
                data.liked.splice(index, 1);
                data.save();

                res.json(200, {"message": "Event unliked"});
            }
        })
    })
    .get(function(req, res) {
        User.findOne({
            _id : req.params.id
        })
        .populate('liked')
        .exec(function(err, data) {
            if (err) {
                return res.json(500, err);
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"});
            }

            res.json(200, data.liked)
        })
    })

router.route('/:id/viewed')
    .post(function(req, res) {
        if (!req.query.eventId) {
            return res.json(400, {"message": "EventId required"})
        }
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err)
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = data.liked.indexOf(eventId)
            if (index >= 0) {
                res.json(403, {"message": "User has already viewed this event"})
            } else {
                data.viewed.push(eventId);
                data.save();

                res.json(200, {"message": "Event viewed"});
            }
        })
    })
    .delete(function(req, res) {
        if (!req.query.eventId) {
            return res.json(400, {"message": "EventId required"})
        }
        var eventId = req.query.eventId;

        User.findOne({
            _id : req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err)
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"})
            }

            var index = data.viewed.indexOf(eventId)
            if (index < 0) {
                res.json(403, {"message": "User has not viewed this event"})
            } else {
                var index2 = data.liked.indexOf(eventId)
                if (index2 < 0) {
                    data.liked.splice(index2, 1);
                }
                data.viewed.splice(index, 1);
                data.save();

                res.json(200, {"message": "Event unviewed"});
            }
        })
    })
    .get(function(req, res) {
        User.findOne({
            _id : req.params.id
        })
        .populate('viewed')
        .exec(function(err, data) {
            if (err) {
                return res.json(500, err);
            } else if (data == null) {
                return res.json(404, {"message": "User Not Found"});
            }

            res.json(200, data.viewed);
        })
    })

module.exports = router;
