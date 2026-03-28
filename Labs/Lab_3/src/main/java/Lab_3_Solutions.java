import org.w3c.dom.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.*;

public class Lab_3_Solutions {

    public static void main(String[] args) throws Exception {
        exercise1();
        exercise2();
        exercise3();
        exercise4();
        exercise5();
    }

    public static void exercise1() throws Exception {
        Document doc = loadXml("document.xml");
        XPath xpath = XPathFactory.newInstance().newXPath();

        XPathExpression expr = xpath.compile("/document/reference/@href");
        String href = (String) expr.evaluate(doc, XPathConstants.STRING);

        System.out.println("Exercise 1:");
        System.out.println("href = " + href);
        System.out.println();
    }

    public static void exercise2() throws Exception {
        Document doc = loadXml("jobs.xml");
        XPath xpath = XPathFactory.newInstance().newXPath();

        XPathExpression expr = xpath.compile("count(/jobs/job[@priority='low'])");
        Double count = (Double) expr.evaluate(doc, XPathConstants.NUMBER);

        System.out.println("Exercise 2:");
        System.out.println("Low priority jobs = " + count.intValue());
        System.out.println();
    }

    public static void exercise3() throws Exception {
        Document doc = loadXml("persons.xml");
        XPath xpath = XPathFactory.newInstance().newXPath();

        XPathExpression expr = xpath.compile("/persons/person[@age > 35]");
        NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

        System.out.println("Exercise 3:");
        for (int i = 0; i < nodes.getLength(); i++) {
            printPerson(nodes.item(i));
        }
        System.out.println();
    }

    public static void exercise4() throws Exception {
        Document doc = loadXml("persons.xml");
        XPath xpath = XPathFactory.newInstance().newXPath();

        XPathExpression expr = xpath.compile("/persons/person[starts-with(@lastName, 'H')]");
        NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

        System.out.println("Exercise 4:");
        for (int i = 0; i < nodes.getLength(); i++) {
            printPerson(nodes.item(i));
        }
        System.out.println();
    }

    public static void exercise5() throws Exception {
        Document doc = loadXml("persons.xml");
        XPath xpath = XPathFactory.newInstance().newXPath();

        XPathExpression expr = xpath.compile("/persons/person[string-length(@firstName) < 5]");
        NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

        System.out.println("Exercise 5:");
        for (int i = 0; i < nodes.getLength(); i++) {
            printPerson(nodes.item(i));
        }
        System.out.println();
    }

    public static Document loadXml(String fileName) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(Lab_3_Solutions.class.getClassLoader().getResourceAsStream(fileName));
    }

    public static void printPerson(Node node) {
        NamedNodeMap attrs = node.getAttributes();
        String firstName = attrs.getNamedItem("firstName").getNodeValue();
        String lastName = attrs.getNamedItem("lastName").getNodeValue();
        String age = attrs.getNamedItem("age").getNodeValue();

        System.out.println(firstName + " " + lastName + " - age " + age);
    }
}