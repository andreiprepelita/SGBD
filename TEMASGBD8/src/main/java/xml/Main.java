/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package xml;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;
/**
 *
 * @author andre
 */
public class Main {
     public static void main(String[] args) {
        try {
         File inputFile = new File("catalog.xml");
         DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
         DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
         Document doc = dBuilder.parse(inputFile);
         doc.getDocumentElement().normalize();
         System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
         NodeList nList = doc.getElementsByTagName("student");
         System.out.println("----------------------------");
         
         for (int temp = 0; temp < nList.getLength(); temp++) {
            Node nNode = nList.item(temp);
            System.out.println("\nCurrent Element :" + nNode.getNodeName());
            
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
               Element eElement = (Element) nNode;
               System.out.println("Prenume : " 
                  + eElement
                  .getElementsByTagName("prenume")
                  .item(0)
                  .getTextContent());
               System.out.println("Nume: " 
                  + eElement
                  .getElementsByTagName("nume")
                  .item(0)
                  .getTextContent());
               System.out.println("An : " 
                  + eElement
                  .getElementsByTagName("an")
                  .item(0)
                  .getTextContent());
               System.out.println("Grupa : " 
                  + eElement
                  .getElementsByTagName("grupa")
                  .item(0)
                  .getTextContent());
               System.out.println("Nota : " 
                  + eElement
                  .getElementsByTagName("nota")
                  .item(0)
                  .getTextContent());
               System.out.println("Curs : " 
                  + eElement
                  .getElementsByTagName("curs")
                  .item(0)
                  .getTextContent());
            }
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
     }
}
