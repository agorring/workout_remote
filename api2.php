<?php

//Set the username to root
$username = "root";

//Set the password to root
$password = "root";

$dbName = "id18651203_workout";

//Set the database to API
$idName = "API";

//Connect to the database
$dbConnection = new mysqli("localhost", "$username", "$password", "$dbName");


/******* Inserting Data *******/
//Decode the json data to create a dictionary
$data = json_decode(file_get_contents('php://input'), JSON_NUMERIC_CHECK);

if(!empty($data))
{
    
    //If data contains workoutName, it must be a new workout being sent
    if (isset($data['workoutName'])) {
        $workoutID = mysqli_real_escape_string($dbConnection, $data['workoutID']);
        $workoutName = mysqli_real_escape_string($dbConnection, $data['workoutName']);
        
        //If the workoutID is less than 0 then the record is not valid
        if ($workoutID > 0) {
        
            $query = "INSERT INTO `workouts`(`workoutName`)
                        VALUES ('$workoutName')";

            print($query);

            $queryResults = $dbConnection->query($query);

            print($queryResults);
        }
    }
    
    //If data contains an exerciseID, it must be a new result being sent
    if (isset($data['exerciseID'])) {
        $exerciseID = mysqli_real_escape_string($dbConnection, $data['exerciseID']);
        $workoutID = mysqli_real_escape_string($dbConnection, $data['workoutID']);
        $date = mysqli_real_escape_string($dbConnection, $data['date']);
        $weight = mysqli_real_escape_string($dbConnection, $data['weight']);
        $reps = mysqli_real_escape_string($dbConnection, $data['reps']);

        //If the exerciseID is less than 0 then the record is not valid
        if ($exerciseID > 0) {
        
            $query = "INSERT INTO `results`(`exerciseID`, `workoutID`, `date`, `weight`, `reps`)
                        VALUES ('$exerciseID', '$workoutID', '$date', '$weight', '$reps')";

            print($query);

            $queryResults = $dbConnection->query($query);

            print($queryResults);
        }
    }
    
    //If data contains an exerciseName, it must be a new exercise being sent
    if (isset($data['exerciseName'])) {
        $exerciseName = mysqli_real_escape_string($dbConnection, $data['exerciseName']);
        $workoutID = mysqli_real_escape_string($dbConnection, $data['workoutID']);
        $weight = mysqli_real_escape_string($dbConnection, $data['weight']);
        $reps = mysqli_real_escape_string($dbConnection, $data['reps']);

        //If the workoutID is less than 0 then the record is not valid
        if ($workoutID > 0) {
        
            $query = "INSERT INTO `exercises`(`exerciseName`, `workoutID`, `weight`, `reps`)
                        VALUES ('$exerciseName', '$workoutID', '$weight', '$reps')";

            print($query);

            $queryResults = $dbConnection->query($query);

            print($queryResults);
        }
    }


}


/***** RECEIVING DATA ******/
$requestedData = $_GET['data'];

if(!empty($requestedData))
{
    if($requestedData == "W")
    {
        $searchQuery = "SELECT `workoutID`, `workoutName` FROM `workouts`";

        $searchResults = $dbConnection -> query($searchQuery);

        $resultsFound = array();

        while($rowResult = $searchResults -> fetch_assoc())
        {
            $resultsFound[] = array("workoutID" => $rowResult['workoutID'],  "workoutName" => $rowResult['workoutName']);

        }
        $returnData = json_encode($resultsFound, JSON_NUMERIC_CHECK);

        print($returnData);
    }
    else if($requestedData == "E")
    {
        $searchQuery = "SELECT `exerciseID`, `exerciseName`, `workoutID`, `weight`, `reps` FROM `exercises`";

        $searchResults = $dbConnection -> query($searchQuery);

        $resultsFound = array();

        while($rowResult = $searchResults -> fetch_assoc())
        {
            $resultsFound[] = array("exerciseID" => intval($rowResult['exerciseID']),  "exerciseName" => $rowResult['exerciseName'], "workoutID" => intval($rowResult['workoutID']), "weight" => intval($rowResult['weight']), "reps" => intval($rowResult['reps']));
        }

        $returnData = json_encode($resultsFound);

        print($returnData);
    }
    else if($requestedData == "R")
    {
        $searchQuery = "SELECT `exerciseID`, `workoutID`, `date`, `weight`, `reps` FROM `results`";

        $searchResults = $dbConnection -> query($searchQuery);

        $resultsFound = array();

        while($rowResult = $searchResults -> fetch_assoc())
        {

            $resultsFound[] = array("exerciseID" => intval($rowResult['exerciseID']), "workoutID" => doubleval($rowResult['workoutID']), "date" => $rowResult['date'], "weight" => doubleval($rowResult['weight']), "reps" => doubleval($rowResult['reps']));

        }

        $returnData = json_encode($resultsFound);

        print($returnData);
    }
    
}
?>

