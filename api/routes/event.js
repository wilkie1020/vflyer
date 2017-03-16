var Event = require('../models/event');
var express = require('express');
var router = express.Router();

router.route('/')
    .post(function(req, res) {
        var event = new Event(req.body);
        event.save(function(err, data) {
            if (err) {
                return res.json(500, err);
            }

            res.json(201, {"_id": data._id});
        })
    })
    .get(function(req, res) {
        var coords = [Number];
        coords[0] = req.query.lon;
        coords[1] = req.query.lat;

        var distance = Number(req.query.r);

        var query = {
            location: {
                $near : {
                    $geometry : {
                        type : "Point",
                        coordinates : coords
                    },
                    $maxDistance : distance
                }
            }
        };

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
            }

            res.json(200, data);
        })
    })

module.exports = router;
