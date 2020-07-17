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
//creating a class which runs for every 24 hours
class myclass1 extends TimerTask{
	
	final String user="root";
	final String pass="********";
	public  void func() throws SQLException, ClassNotFoundException, ParseException{
		System.out.println(new Date());
		try {
			
			String url="jdbc:mysql://localhost:3306/inventory?" + "autoReconnect=true&useSSL=false";
			Class.forName("com.mysql.jdbc.Driver");
			//connecting to database
			final Connection con=DriverManager.getConnection(url,user,pass);
			Statement stmt=con.createStatement();
			
			ResultSet rs=stmt.executeQuery("select id,code,product_exp_date from purchase");
		//creating a setup to send mail
			final String sendermail="********@gmail.com";
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
				Message stock_expired=new MimeMessage(ses);
				msg.setFrom(new InternetAddress("********@gmail.com"));
				msg.setRecipients(Message.RecipientType.TO,InternetAddress.parse("********@gmail.com"));
			msg.setSubject("Items which are going to be expired in 4 days");
			
			stock_expired.setFrom(new InternetAddress("********@gmail.com"));
			stock_expired.setRecipients(Message.RecipientType.TO,InternetAddress.parse("********@gmail.com"));
			stock_expired.setSubject("These are going to be expired today and will be removed from database");
String message="";
if(rs==null)
	return;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
Date datenow = sdf.parse(sdf.format(new Date()));
Calendar cal = Calendar.getInstance();
datenow = cal.getTime();

int f=0;
String exp_string="";
//checking which items are going to be expired
while(rs.next()) {
	String st=rs.getString(3);
	st=st+" 00:00";
	String id=rs.getString(1);
    Date date1=new SimpleDateFormat("yyyy-MM-dd hh:mm").parse(st);
    long diff = date1.getTime() - datenow.getTime();
    
	int diffDays = (int) (diff / (24 * 60 * 60 * 1000));
    System.out.println(st+" "+date1+" "+diffDays);
    if(diffDays>=5) {
    	continue;
    }
    if(diffDays==0) {
    	//if expires today delete from database
    	exp_string=exp_string+"Id: "+id+" Code: "+rs.getString(2)+"\n";
    	
    	 String sql = "delete from purchase where id="+id;
    	 Statement stmt_del = con.createStatement();
    	      
    	      stmt_del.executeUpdate(sql);
    	 
    	 continue;
    }
    	f=1;
    			
	message=message+"Id: "+id+" Code: "+rs.getString(2)+"\n";
}
if(exp_string!=""){
	//if stock went to 0 send a mail to the admin
	stock_expired.setText(exp_string);
	Transport.send(stock_expired);
}
if(f==0)
	return;
//if there is some stock which is going to be expired within 4 days send a message to the admin
			msg.setText(message);
			
			Transport.send(msg);
			
			}
			catch(MessagingException e) {
				System.out.println("Message could not be semd"+e);
			}
		

	}
@Override
	public void run() {
	try {
	func();
			}
	catch(Exception e){
		System.out.println(e);
	}
}
}




%>
<%
//creating an instance for Time class
Timer timer=new Timer();
TimerTask ts=new myclass1();
timer.schedule(ts, 0,1000*60*60*24);

%>
</body>
</html>