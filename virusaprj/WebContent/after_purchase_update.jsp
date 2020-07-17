<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.util.Date,java.text.ParseException,java.util.Calendar,java.util.Properties,java.text.SimpleDateFormat,java.sql.*,javax.mail.*,java.util.Timer,java.util.TimerTask,javax.mail.Transport,javax.mail.internet.MimeMessage,javax.mail.internet.InternetAddress" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>

</head>
<body>
<%
String user="root";
String pass="*****";
String product_id = request.getParameter("pro_id");
String quantity_got=request.getParameter("quantity");
if(quantity_got==""){
	 String redirectToWrong = "Wrong.jsp";
     response.sendRedirect(redirectToWrong);
}
else{
int quant=Integer.parseInt(quantity_got);
String url="jdbc:mysql://localhost:3306/inventory?" + "autoReconnect=true&useSSL=false";
Class.forName("com.mysql.jdbc.Driver");
//connecting to database
Connection con=DriverManager.getConnection(url,user,pass);
Statement stmt=con.createStatement();
ResultSet rs1=stmt.executeQuery("select quantity from purchase where id="+product_id);


int available=0;
while(rs1.next()){
available=Integer.valueOf(rs1.getString(1));}

if(available<quant){
	 String redirectURLIn = "Insufficient.jsp";
     response.sendRedirect(redirectURLIn);
} 

else if(available==quant){
	//After purchase if stock becomes 0 send a mail to admin
	String del_str = "delete from purchase where id="+product_id;
	 Statement stmt_del = con.createStatement();
	      
	      stmt_del.executeUpdate(del_str);
	      //Setup to send a mail
	      final String sendermail="**********@gmail.com";
	      final String password="********";
	      Properties props=new Properties();
	      props.put("mail.smtp.auth","true");
	      props.put("mail.smtp.starttls.enable","true");
	      props.put("mail.smtp.host","smtp.gmail.com");
	      props.put("mail.smtp.port","587");

	      Session ses=Session.getInstance(props,new javax.mail.Authenticator() {
	      	protected PasswordAuthentication getPasswordAuthentication() {
	      		return new PasswordAuthentication(sendermail,password);
	      	}
	      });
	      	Message msg=new MimeMessage(ses);
	      	msg.setFrom(new InternetAddress("**********@gmail.com"));
	      	msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse("**********@gmail.com"));
	      msg.setSubject("Item went to zero stock after purchase");
msg.setText("Product with id : "+product_id+" is finished after a purchase made");

	      Transport.send(msg);
	      
	      
	     
}
else{
	//Update quantity after purchase
	int id_product=Integer.valueOf( product_id );
	String remaining=Integer.toString(available-quant);
	PreparedStatement update_stm = con.prepareStatement("UPDATE purchase SET quantity=? WHERE id=?");
	update_stm.setString(1, remaining);
	update_stm.setInt(2, id_product);
	update_stm.executeUpdate();

 
        String redirectURL = "Purchased.jsp";
        response.sendRedirect(redirectURL);
}
}
    %>

</body>
</html>