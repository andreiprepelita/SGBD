<html>

<body>
    <p> BINE ATI VENIT IN TABELA STUDENTI</p>
    <p> Alegeti optiunea de mai jos </p>
    <form action="test.php" method="post">
    <input type='submit' value="Nume ASC" name='2' />
        <form action="test.php" method="post">
            <input type='submit' value="Nume DESC" name='3' />
            <form action="test.php" method="post">
                <input type='submit' value="Prenume ASC" name='4' />
                <form action="test.php" method="post">
                    <input type='submit' value="Prenume DESC" name='5' />
                    <form action="test.php" method="post">
                        <input type='submit' value="An ASC" name='6' />
                        <form action="test.php" method="post">
                            <input type='submit' value="An DESC" name='7' />
                            <button type='button' name="buttton"> submit </button>
                                <br>
                                <br>
                                <form action="test.php" method="post">
                                    Dati un criteriu <input type="text" name="name">
                                    <input type="submit" name='8' />


                                </form>
                                <?php
                                // Connects to the XE service (i.e. database) on the "localhost" machine
                                //OCI-oracle call interface
                                //oci_connect - se conecteaza la baza de date oracle prin variabila conn
                                $conn = oci_connect('student', 'STUDENT', 'localhost/XE');
                                if (!$conn) { //daca nu se poate conecta
                                    $e = oci_error(); //returns the last error found
                                    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
                                    //htmlentities modifica fiecare caracter in entitati html (string care incepe cu & si se termina cu ;)
                                    //E_USER_ERROR iti afiseaza tipul de eroare care exista
                                }
                                
                                if (isset($_POST['2'])) {
                                   
                                        $s = oci_parse($conn, "SELECT nume,prenume,an,grupa FROM studenti order by nume");
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
                                } else
if (isset($_POST['3'])) {
                                    $s = oci_parse($conn, 'SELECT nume,prenume,an,grupa FROM studenti order by nume DESC');
                                    oci_execute($s); //executes a statment

                                    echo "<table border='1'>\n";
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
                                } else
if (isset($_POST['4'])) {
                                    $s = oci_parse($conn, 'SELECT nume,prenume,an,grupa FROM studenti order by prenume ASC');
                                    oci_execute($s); //executes a statment

                                    echo "<table border='1'>\n";
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
                                } else
if (isset($_POST['5'])) {
                                    $s = oci_parse($conn, 'SELECT nume,prenume,an,grupa FROM studenti order by prenume DESC');
                                    oci_execute($s); //executes a statment

                                    echo "<table border='1'>\n";
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
                                } else
if (isset($_POST['6'])) {
                                    $s = oci_parse($conn, 'SELECT nume,prenume,an,grupa FROM studenti order by an ASC');
                                    oci_execute($s); //executes a statment

                                    echo "<table border='1'>\n";
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
                                } else
if (isset($_POST['7'])) {
                                    $s = oci_parse($conn, 'SELECT nume,prenume,an,grupa FROM studenti order by an DESC');
                                    oci_execute($s);

                                    echo "<table border='1'>\n";
                                    while ($row = oci_fetch_array($s, OCI_ASSOC + OCI_RETURN_NULLS)) {
                                        echo "<tr>\n";
                                        foreach ($row as $item) {
                                            echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                                        }
                                        echo "</tr>\n";
                                    }
                                    echo "</table>\n";
                                } else
if (isset($_POST['8'])) {
                                   
                                    $b = "SELECT nume,prenume,an,grupa FROM studenti where ";
                                    $b = $b . $_POST["name"];
                                   
                                    $s = oci_parse($conn, $b);

                                    oci_execute($s);

                                    echo "<table border='1'>\n";
                                    while ($row = oci_fetch_array($s, OCI_ASSOC + OCI_RETURN_NULLS)) {
                                        echo "<tr>\n";
                                        foreach ($row as $item) {
                                            echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                                        }
                                        echo "</tr>\n";
                                    }
                                    echo "</table>\n";
                                   
                                      
                                        $s=$b;
                                        if (isset($_GET['buttton']))
                                        {   echo "{A{A{A{A\n";
                                             $s=$s. " order by nume";
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
                                    }
                                


                                ?>
</body>

</html>