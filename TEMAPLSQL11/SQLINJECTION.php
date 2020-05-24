<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <p> Dati numele unui student pentru a afisa bursa,anul si grupa in care se afla</p>
    <form action="TEMAPLSQL11.php" method="post">
  <label for="lname">Nume</label>
  <input type="text" id="fname" name="lname">
  <input type="submit" value="Submit">
</form>
<?php
if(isset($_POST['lname']))
    {   
        $conn = oci_connect('student', 'STUDENT', 'localhost/XE');
        if (!$conn) { //daca nu se poate conecta
            $e = oci_error(); //returns the last error found
            trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
            error_reporting(E_ERROR | E_PARSE);     
          
        }
        $querry="SELECT nume,prenume,nvl(bursa,0),an,grupa FROM studenti where nume='" . $_POST['lname'] ."'";
        echo $querry;
        $s = oci_parse($conn,$querry);
        oci_execute($s); //executes a statment

        echo "<table border='s1'>\n";
        while ($row = oci_fetch_array($s, OCI_ASSOC + OCI_RETURN_NULLS)) { //returneaza urmatoarea linie din interogare
            echo "<tr>\n"; //imi mai face o celula
            foreach ($row as $item) { //pentru fiecare element din rand
                echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                //daca exista valoare intr-o celula
                // afiseaza valoarea
                //altfel lasa spatiu gol
            }
            echo "</tr>\n";
        }
        echo "</table>\n";
    }
    //' OR '1'='1
?>

</body>
</html>

