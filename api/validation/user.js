var validation = {
    'userId': {
        notEmpty: {
            errorMessage: "Must not be left empty"
        }
    },
    'radius': {
        isInt: {
            errorMessage: "Must be an integer"
        }
    }
};

module.exports = validation;
