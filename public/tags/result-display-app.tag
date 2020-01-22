<result-display-app>
	<!-- NOTE: that this is a base application for you to play with and contains zero firebase code. I will be using this exact same application in the WatchMe videos where we progressively add firebase code and build out the data integration. -->

	<br>
	<br>
	<h1>CUSSA Chinese New Year Gala 2020</h1>
	<h2>Drawing Results</h2>
	<br>
	<br>

	<div class="row">
		<div class="col-md-4 col-md-offset-4">
			<h3 class="page-header">WINNER LIST</h3>

			<result-item each={ resultsData } id="display-area"></result-item>

			<div class="form-group">
				<input class="form-control" type="text" placeholder="Enter Prize Type and Winner Number" onkeypress={ addItem }>
			</div>

			<div class="form-group">
				<button class="btn btn-danger" disabled={ resultsData.filter(onlyDone).length == 0 } onclick={ removeItems }>
					<i class="fa fa-trash"></i> { resultsData.filter(onlyDone).length }
				</button>
			</div>

		</div>
	</div>

	<script>
		var that = this;

		// STATIC data that eventually will come from Firebase
		this.resultsData = [];
		// this.resultsData = [{
		// 	task: "Item A",
		// 	done: true
		// },{
		// 	task: "Item B",
		// 	done: false
		// },{
		// 	task: "Item C",
		// 	done: false
		// }];

		// First thing we want to do is read the data on the tag load.
		var database = firebase.database();
		var todoItemsRef = database.ref('todoItems');

		// todoItemsRef.on('value', function(snapshot) {
		// 	console.log(snapshot.val());
		// 	var data = snapshot.val(); // Object with properties as keys
		//
		// 	var todos = [];
		//
		// 	// Transform into array with indices as keys
		// 	for (var key in data) {
		// 		todos.push(data[key]);
		// 	}
		//
		// 	that.resultsData = todos;
		// 	that.update();
		// });

		todoItemsRef.on('child_added', function(snapshot) {

			var data = snapshot.val(); // Object with properties as keys
					data.id = snapshot.key;

			that.resultsData.push(data);
			that.update();
		});

		todoItemsRef.on('child_removed', function(snapshot) {
			var data = snapshot.val(); // Object with properties as keys
			var key = snapshot.key;

			var targetTodo;

			for (var i = 0; i < that.resultsData.length; i++) {
				if (that.resultsData[i].id === key) {
					targetTodo = that.resultsData[i];
					break;
				}
			}

			var index = that.resultsData.indexOf(targetTodo);

			that.resultsData.splice(index, 1);

			that.update();
		});

		// To understand the event object better see:
		// http://riotjs.com/guide/#event-handlers
		// http://riotjs.com/guide/#event-object
		addItem(event){
			var newTask = {};
			if (event.which === 13) {
				newTask.task = event.target.value;	// Grab the user task value
				newTask.done = false;

				// But we need a more specific reference.
				// That's where a new key comes in handy.
				// Let's push a new node to the 'todoItems' reference.
				var newKey = todoItemsRef.push().key;

				// newTask.id = newKey;

				// Now we have a unique and specific reference to write our data.
				todoItemsRef.child(newKey).set(newTask);

				event.target.value = "";	// RESET INPUT
				event.target.focus();			// FOCUS BACK ON INPUT
			}
		}

		removeItems(event){
			this.resultsData = this.resultsData.filter(function(item) {
        return !item.done;
      });

			// HINT for removing on firebase
			// REFERENCE.remove();
			// REFERENCE.set(null);
		}

		onlyDone(item) {	// Iterator function for the Array.filter(iterator) method...
			return item.done === true;
		}
	</script>

	<style>
		:scope {
			display: block;
		}

		#display-area {
			background-color: #bbbbbb;
		}

		h1 {
    text-align: center;
		color: #8a0900;
}

h2 {
    text-align: center;
		color: #8a0900;
}

h3 {
    text-align: center;
		color: #8a0900;
}


	</style>
</result-display-app>
