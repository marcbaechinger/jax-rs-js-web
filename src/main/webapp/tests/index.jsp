<!DOCTYPE html>
<html>
    <head>
        <title>Integrationtests jax-rs-js</title>
        <link rel="stylesheet" type="text/css" href="../styles/qunit.css"/>
        <script src="../js/jquery.js"> </script>
        <script src="../js/qunit.js"> </script>
        <script src="<%= request.getContextPath() %>/resources-js/"> </script>
        <script>
            $(function() {
                
               module("GET: to retrieve JSON data");
               asyncTest("no arguments; returns list of Note beans", function() {
                    jaxjs.services.NotesService.getAll(function(notes) {
                        ok(notes, "retrieved an array of notes from 'getAll'");
                        equal(2, notes.length, "getAll is expected to return two notes");
                        start();
                    });
                });
                asyncTest("map a single path param to method arguments (note/{id}); return a single object", function() {
                    jaxjs.services.NotesService.get(34, function(note) {
                        ok(note, "note retrieved");
                        ok(note.id);
                        ok(note.title);
                        start();
                    });
                });
                asyncTest("map two path params to method arguments (note/{id}/comments/{commentId}; return List of Comment beans", function() {
                   jaxjs.services.NotesService.getComments(2, 99, function(comments) {
                        ok(comments, "retrieved ")
                        equal(2, comments.length, "getComments(2, 99, callback) is expected to return an array with two items");
                        start();
                    }); 
                });
                asyncTest("support for Arrays as return value", function() {
                   jaxjs.services.NotesService.getAllAsArray(function(notes) {
                        ok(notes, "retrieved ")
                        equal(2, notes.length, "getAllAsArray(callback) is expected to return an array with two items");
                        start();
                    }); 
                });
                
                
                module("POST: sending and retrieving JSON data");
                asyncTest("POSTs JSON data as body returns created note with id", function() {
                    jaxjs.services.NotesService.addNote(
                    {
                        title: "a<b>הצü</b>dd note 99",
                        note: "a note added"
                    },
                    function(note) {
                        ok(note, "note not undefined");
                        ok(note.id, "id not undefined");
                        equal(note.id, 109);
                        console.log("title", note.title);
                        ok(note.title, "title undefined");
                        start();
                    });
                });
                
                asyncTest("support for List as method arguments", function() {
                    jaxjs.services.NotesService.addNotes(
                        [
                            {title: "Note 1 batch"},
                            {title: "Note 2 batch"},
                            {title: "Note 3 batch"}
                        ],
                        function(notes) {
                            ok(notes, "retrieved ")
                            equal(3, notes.length, "getAllAsArray(callback) is expected to return an array with two items");
                            equal(1, notes[0].id);
                            equal(2, notes[1].id);
                            equal(3, notes[2].id);
                            ok(notes[0].title);
                            ok(notes[1].title);
                            ok(notes[2].title);
                            start();
                        }
                    ); 
                });
                asyncTest("support for Array as method arguments", function() {
                    jaxjs.services.NotesService.addNotesAsArray(
                        [
                            {title: "Note 1 batch"},
                            {title: "Note 2 batch"},
                            {title: "Note 3 batch"}
                        ],
                        function(notes) {
                            ok(notes, "retrieved ")
                            equal(3, notes.length, "getAllAsArray(callback) is expected to return an array with two items");
                            equal(1, notes[0].id);
                            equal(2, notes[1].id);
                            equal(3, notes[2].id);
                            start();
                        }
                    ); 
                });
                
                
                module("PUT: sending and retrieving JSON data");
                asyncTest("sends a JSON body and a pathParam to be mapped to method arguments; returns updated entitity", function() { 
                    jaxjs.services.NotesService.updateNote(1,
                    {
                        id: 199,
                        title: "update note 99",
                        note: "a note updated"
                    },
                    function(note) {
                        ok(note, "note not undefined");
                        ok(note.id, "id not undefined");
                        equal(note.id, 199);
                        ok(note.title, "title not undefined");
                        start();
                    });
                });
                
                
                module("DELETE: sending pathParam and retrieving JSON data");
                asyncTest("sends a JSON body and pathParam to be mapped to a method param; returns deleted entity", function() {
                    jaxjs.services.NotesService.removeNote(13,
                        function(note) {
                            ok(note, "note not undefined");
                            ok(note.id, "id not undefined");
                            equal(note.id, 13);
                            ok(note.title, "title not undefined");
                            start();
                    });
                });
                
                
                module("Exception handling");
                asyncTest("calling a method throwing an exception (http status > 399 and a simple response text)", function() {
                    jaxjs.services.NotesService.getReferences(1, 2,
                        function(note) { /* left blank intentionally */},
                        function(error) {
                            ok(error, "error handler called and 'error' available as argument");
                            ok(error.status > 399, "http status above 399");
                            ok(error.responseText, "error.responseText available");
                            equal(error.responseText, "Elephant panic! Run!!", "Error message is expected to be 'Elephant panic! Run!!'");
                            start();
                        }
                    );
                });
                asyncTest("use global error handler", function() {
                    jaxjs.services.NotesService.setGlobalErrorHandler(function(error) {
                        ok(error, "error handler called and 'error' available as argument");
                        ok(error.status > 399, "http status above 399");
                        ok(error.responseText, "error.responseText available");
                        equal(error.responseText, "Elephant panic! Run!!", "Error message is expected to be 'Elephant panic! Run!!'");
                        start();
                        jaxjs.services.NotesService.setGlobalErrorHandler(undefined);
                    });
                    jaxjs.services.NotesService.getReferences(1, 2,
                        function(note) { /* left blank intentionally */}
                    );
                });
                asyncTest("method error handler has precedence over global error handler", function() {
                    jaxjs.services.NotesService.setGlobalErrorHandler(function(error) {
                        fail("global error handler should not be called");
                    });
                    jaxjs.services.NotesService.getReferences(1, 2,
                        function(note) { /* left blank intentionally */},
                        function(error) {
                            ok(error, "error handler called and 'error' available as argument");
                            ok(error.status > 399, "http status above 399");
                            ok(error.responseText, "error.responseText available");
                            equal(error.responseText, "Elephant panic! Run!!", "Error message is expected to be 'Elephant panic! Run!!'");
                            start();
                            jaxjs.services.NotesService.setGlobalErrorHandler(undefined);
                        }
                    );
                });
            });
        </script>
    </head>
    <body>
        <h1 id="qunit-header">Integrationtests of generated <code>jaxjs.services.NotesService</code> service with JAX-RS</h1>
        <h2 id="qunit-banner"></h2>
        <div id="qunit-testrunner-toolbar"></div>
        <h2 id="qunit-userAgent"></h2>
        <ol id="qunit-tests"></ol>
        <div id="qunit-fixture">test markup, will be hidden</div>
    </body>
</html>
