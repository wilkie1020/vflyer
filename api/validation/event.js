var validation = {
    'name': {
        notEmpty: {
            errorMessage: "Must not be empty"
        }
    },
    'location': {
        isValidGeoJSON: {
            errorMessage: "Invalid GeoJSON object"
        }
    },
    'description': {
        notEmpty: {
            errorMessage: "Must not be empty"
        }
    },
    'startDate': {
        isISO8601: {
            errorMessage: "Invalid date format"
        }
    },
    'endDate': {
        isISO8601: {
            errorMessage: "Invalid date format"
        }
    }
};

module.exports = validation;
