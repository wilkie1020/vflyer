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
        });

        var event = new Event(req.body);
        event.save(function(err, data) {
            if (err) {
                return res.json(500, err);
            }

            res.json(201, {"_id": data._id});
        })
    })
    .get(function(req, res) {
        req.checkQuery('lon', 'Invalid longitude').isFloat();
        req.checkQuery('lat', 'Invalid latitude').isFloat();
        req.checkQuery('r', 'Invalid radius').isInt();

        req.sanitize('lon').toFloat();
        req.sanitize('lat').toFloat();
        req.sanitize('r').toInt();

        req.getValidationResult().then(function(result) {
            if (!result.isEmpty()) {
              return res.json(400, result.array());
            }
        });

        var query = {};
        if (req.query.lon && req.query.lat && req.query.r) {
            var coords = [Number];
            coords[0] = req.query.lon;
            coords[1] = req.query.lat;

            var distance = req.query.r;

            query.location = {
                $near : {
                    $geometry : {
                        type : "Point",
                        coordinates : coords
                    },
                    $maxDistance : distance
                }
            }
        }

        Event.find(query, function(err, events) {
            if (err) {
                return res.json(500, err);
            }

            res.json(200, events);
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
                return res.json(404, {"message": "User Not Found"})
            }

            res.json(200, data);
        })
    })
    .delete(function(req, res) {
        Event.remove({
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

module.exports = router;
