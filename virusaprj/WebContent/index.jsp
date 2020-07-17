<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.util.ArrayList,java.util.Date,java.text.ParseException,java.util.Calendar,java.util.Properties,java.text.SimpleDateFormat,java.sql.*,javax.mail.*,java.util.Timer,java.util.TimerTask,javax.mail.Transport,javax.mail.internet.MimeMessage,javax.mail.internet.InternetAddress" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<style>
.card {
display: grid;
margin:30px;
box-shadow: 2px 5px 5px black;
float:left;
border-radius:25px;
 padding: 20px;
  max-width: 300px;
  width: 450px;
  height: 450px;
  margin: 50 px 50px 50px 50px;
  text-align: center;
  font-family: arial;
}
.card:hover{
 background-color: #EEEEEE;
}

.price {
  color: grey;
  font-size: 22px;
}
.quant {
  color: grey;
  font-size: 20px;
}
.inp_box{
diplay:block;
margin:20px;
width:180px;
}
.card button {
  border: none;
  outline: 0;
  padding: 12px;
  color: white;
  background-color: #000;
  text-align: center;
  cursor: pointer;
  width: 100%;
  font-size: 18px;
}

.card button:hover {
  opacity: 0.7;
}

</style>
</head>
<body>
<%
String user="root";
String pass="*******";

String url="jdbc:mysql://localhost:3306/inventory?" + "autoReconnect=true&useSSL=false";
Class.forName("com.mysql.jdbc.Driver");

Connection con=DriverManager.getConnection(url,user,pass);
Statement stmt=con.createStatement();
ResultSet rs=stmt.executeQuery("select * from purchase");

ArrayList<ArrayList<String>> avail_product =new ArrayList<ArrayList<String>>();
ArrayList<String> curr_product=new ArrayList<String>();
while(rs.next()){
	
	curr_product.add(rs.getString(1));
	curr_product.add(rs.getString(4));
	curr_product.add(rs.getString(5));
	curr_product.add(rs.getString(6));
	curr_product.add(rs.getString(7));
	curr_product.add(rs.getString(9));
	avail_product.add(curr_product);
	curr_product=new ArrayList<String>();
}
int number_of_products=avail_product.size();

%>
<table>
<%for(int i=0;i<number_of_products;){ %>
<tr>
<td><div class="card">
<form action="after_purchase_update.jsp" method="post">
<% String product_image= "images\\"+avail_product.get(i).get(2)+avail_product.get(i).get(1)+".png";
%>
<input name="pro_id" type="hidden" value="<%= avail_product.get(i).get(0) %>">
 <img src="<%=product_image %>" alt="<%=avail_product.get(i).get(2) %>" width="200px" height="150px">
  <h2><%=avail_product.get(i).get(2) %> <%=avail_product.get(i).get(1) %></h2>
  <p class="quant">Available Quantity : <%=avail_product.get(i).get(4) %> </p>
  <p class="price">Price : <%=avail_product.get(i).get(5) %> </p>
  <input type="text" name="quantity" class="inp_box" placeholder="Enter the quantity you want">
<button class="card_buton" type="Submit">Submit</button></form>
<%i+=1; %>

</div></td>
<% 
if(i<number_of_products){
%><td><div class="card">
<form action="after_purchase_update.jsp" method="post">
<% String product_image2= "images\\"+avail_product.get(i).get(2)+avail_product.get(i).get(1)+".png";
%>
<input name="pro_id" type="hidden" value="<%= avail_product.get(i).get(0) %>">
 <img src="<%=product_image2 %>" alt="<%=avail_product.get(i).get(2) %>" width="200px" height="150px">
  <h2><%=avail_product.get(i).get(2) %> <%=avail_product.get(i).get(1) %></h2>
  <p class="quant">Available Quantity : <%=avail_product.get(i).get(4) %> </p>
  <p class="price">Price : <%=avail_product.get(i).get(5) %> </p>
  <input type="text" name="quantity" class="inp_box" placeholder="Enter the quantity you want">
<button class="card_buton" type="Submit">Submit</button></form>
<%i+=1; %>

</div></td>

<%} %>  
</tr>
<%} %>
</table>
</body>
</html>