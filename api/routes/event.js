var Event = require('../models/event');
var eventValidator = require('../validation/event');
var User = require('../models/user');
var express = require('express');
var router = express.Router();

router.route('/')
    .post(function(req, res) {
        req.checkBody(eventValidator);
        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }

            var event = new Event(req.body);
            event.save(function(err, data) {
                if (err) {
                    return res.json(500, err);
                }

                res.json(201, {"_id": data._id});
            });
        });
    })
    .get(function(req, res) {
        req.checkQuery('lon', 'Invalid longitude').isFloat();
        req.checkQuery('lat', 'Invalid latitude').isFloat();
        req.checkQuery('userId', 'Invalid user id').isMongoId();

        req.sanitizeQuery('lon').toFloat();
        req.sanitizeQuery('lat').toFloat();

        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }

            var query = {};
            User.findOne({
                _id: req.query.userId
            }, function(err, user) {
                if (err) {
                    return res.json(500, err);
                } else if (user == null) {
                    return res.json(404, {"message": "User Not Found"})
                }

                query._id = {
                    $nin: user.viewed.map(String)
                }
                query.location = {
                    $near : {
                        $geometry : {
                            type : "Point",
                            coordinates : [req.query.lon, req.query.lat]
                        },
                        $maxDistance : user.radius
                    }
                }
                query.startDate = {
                    $gte: new Date()
                }

                Event.find(query, function(err, events) {
                    if (err) {
                        return res.json(500, err);
                    }

                    res.json(200, events);
                });
            });
        });
    })

router.route('/:id')
    .get(function(req, res) {
        Event.findOne({
            _id: req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err);
            } else if (data == null) {
                return res.json(404, {"message": "Event Not Found"})
            }

            res.json(200, data);
        })
    })
    .put(function(req, res) {
        req.checkBody(eventValidator);

        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }

            Event.findOne({
                _id : req.params.id
            }, function(err, event) {
                if (err) {
                    return res.json(500, err);
                } else if (event == null) {
                    return res.json(404, {"message": "Event Not Found"});
                }

                event.name = req.body.name;
                event.description = req.body.description;
                event.startDate = req.body.startDate;
                event.endDate = req.body.endDate;
                event.save();

                res.json(200, {"message": "Event updated successfully"});
            });
        });
    })
    .delete(function(req, res) {
        Event.remove({
            _id: req.params.id
        }, function(err, data) {
            if (err) {
                return res.json(500, err);
            } else if (data == null) {
                return res.json(404, {"message": "Event Not Found"})
            }

            res.json(200, data);
        })
    })

module.exports = router;
