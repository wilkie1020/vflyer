var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var EventSchema = new Schema({
    name: String,
    location : {
        type: {
          type: String,
          default: 'Point'
        },
        coordinates: [Number]
    },
    image: { data: Buffer, contentType: String },
    description: String,
    startDate: Date,
    endDate: Date
});
EventSchema.index({ location : '2dsphere' });

module.exports = mongoose.model('Event', EventSchema);
