var validation = {
    'name': {
        notEmpty: {
            errorMessage: "Must not be left empty"
        }
    },
    'location': {
        isValidGeoJSON: {
            errorMessage: "Invalid GeoJSON object"
        }
    },
    'image': {
        optional: true,
        notEmpty: {
            errorMessage: "Must not be left empty"
        }
    },
    'description': {
        notEmpty: {
            errorMessage: "Must not be left empty"
        }
    },
    'venue': {
        notEmpty: {
            errorMessage: "Must not be left empty"
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
