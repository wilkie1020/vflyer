var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var UserSchema = new Schema({
    userId: {
        type: String,
        unique: true
    },
    radius: Number,
    liked: [
        { type: Schema.Types.ObjectId, ref: 'Event' }
    ],
    viewed: [
        { type: Schema.Types.ObjectId, ref: 'Event' }
    ]
});

module.exports = mongoose.model('User', UserSchema);
