use vflyer

db.users.remove({})
db.events.remove({})

db.events.insert({
    name: "Regina 1",
    description: "Event @ -104, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -104.6189,
        50.4452
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Regina 2",
    description: "Event @ -104, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -104.6180,
        50.4459
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Regina 3",
    description: "Event @ -104, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -104.617,
        50.44
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Regina 4",
    description: "Event @ -104, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -104.62,
        50.40
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Tor Hill Golf Course",
    description: "Event @ -104, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -104.5,
        50.5
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Balgonie",
    description: "Event @ -104, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -104.268600,
        50.487226
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Fort Qu'Appelle",
    description: "Event @ -103, 50",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -103.787150,
        50.768681
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Saskatoon 1",
    description: "Event @ -106, 52",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -106.6700,
        52.1332
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Saskatoon 2",
    description: "Event @ -106, 52",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -106.6750,
        52.14
      ],
      type: "Point"
    }
});

db.events.insert({
    name: "Saskatoon 3",
    description: "Event @ -106, 52",
    startDate: "2017-06-01T00:00:00.000Z",
    endDate: "2017-06-01T01:00:00.000Z",
    location: {
      coordinates: [
        -106.66,
        52.135
      ],
      type: "Point"
    }
});
