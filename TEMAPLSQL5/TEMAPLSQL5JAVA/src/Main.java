
import java.sql.*;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author andre
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
      
        try{  
 
Class.forName("oracle.jdbc.driver.OracleDriver");  
   
    try (   Connection con = DriverManager.getConnection(  
            "jdbc:oracle:thin:@localhost:1521:xe","student","STUDENT")) {
                try (CallableStatement callStmt = con.prepareCall("{? = call exceptieBursa.getBursa(?)}")) {
                    callStmt.setString(2, "1070");
                    callStmt.registerOutParameter(1, java.sql.Types.NUMERIC);
                    callStmt.execute();
                    
                    System.out.println(callStmt.getInt(1));
                }catch(SQLException e)
                {
                    System.out.println("STUDENTUL NU EXISTA IN BAZA DE DATE");
                } finally {
                    con.close();
                }
//step5 close the connection object
    } 


  
}catch( ClassNotFoundException | SQLException e){ System.out.println(e);}  
    }
    
}
