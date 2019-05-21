import javax.xml.bind.DatatypeConverter;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.HashMap;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.security.*; // library used to compute md5
import java.security.NoSuchAlgorithmException;

/**
 * Simulate an order, through a textual interface
 */
public class PrintOrder {

	/**
	 * The JDBC driver to be used
	 */
	private static final String DRIVER = "org.postgresql.Driver";

	/**
	 * The URL of the database to be accessed
	 */
	private static final String DATABASE = "jdbc:postgresql://127.0.0.1/localproductions";

	/**
	 * The username for accessing the database
	 */
	private static final String USER = "jarvis";

	/**
	 * The password for accessing the database
	 */
	private static final String PASSWORD = "";

	/**
	 * The statement to list the last 15 orders done by a customer
	 */
	private static final String LIST_ORDERS = "SELECT o.order_id, o.order_timestamp, o.total_price, m.type FROM Make AS m "
			+ "INNER JOIN Orders AS o ON m.order_id = o.order_id "
			+ "WHERE customer_email = ? "
			+ "ORDER BY order_id DESC "
			+ "LIMIT 15; ";

	/**
	 * The statement to list the details of an order
	 */
	private static final String LIST_ORDER_DETAIL = "SELECT c.order_id, p.product_code, name, quantity, price AS \"Unit Price\", business_name FROM Contain as c "
			+ "INNER JOIN Make AS m On c.order_id = m.order_id "
			+ "INNER JOIN Product AS p ON c.product_code = p.product_code "
			+ "INNER JOIN Producer AS prdcr ON m.producer_email = prdcr.email "
			+ "WHERE c.order_id::varchar = ? "
			+ "ORDER BY name ASC; ";

	/**
	 * The query to list the future events that will take place in a region
	 */
	//TODO: Sistemare query
	private static final String LIST_EVENTS = "SELECT e.event_id, e.name, description, start_date, end_date, location, region_name FROM Event AS e "
			+ "INNER JOIN Promote AS prm ON prm.event_id = e.event_id "
			+ "WHERE end_date >= CURRENT_DATE AND region_name = ?; ";

	/**
	 * The query to list the 3 most sold product by a producer
	 */
	private static final String LIST_PRODUCER_STATS = "SELECT c.product_code, SUM(c.quantity) AS \"Total Sell\" FROM Make AS m "
			+ "INNER JOIN Orders AS o ON m.order_id = o.order_id "
			+ "INNER JOIN Contain AS c ON m.order_id = c.order_id "
			+ "WHERE m.producer_email = ? AND o.order_status = 'Completed' "
			+ "GROUP BY c.product_code "
			+ "ORDER BY \"Total Sell\" DESC "
			+ "LIMIT 3; ";

	private static final String EMAIL_CHECK = "SELECT * FROM End_User WHERE email = ?;";

	private static final String SELECT_PSW = "SELECT password FROM End_User WHERE email = ?;";

	private static final String ROLE = "SELECT role FROM End_User WHERE email = ?;";

	/**
	 * The connection to the database
	 */
	private Connection con;

	/**
	 * The scanner to use to get data from the user
	 */
	private Scanner scan;

	/**
	 * The user mail
	 */

	private String email;

	/**
	 * The user password
	 */

	private String password;

	/**
	 *
	 * @param user_email
	 */
	private void printOrders(String user_email) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_ORDERS);
			pstmt.setString(1, user_email);
			rs = pstmt.executeQuery();

			System.out.println("Order ID\tOrder Timestamp\tTotal Price\tPayment Method");
			
			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\n", rs.getString("order_id"), rs.getString("order_timestamp"), rs.getString("total_price"), rs.getString("type"));
			}
		} finally{
			if (rs != null) {
				rs.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	/**
	 *
	 * @param order_id
	 */
	private void printOrderDetail(String order_id) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_ORDER_DETAIL);
			pstmt.setString(1, order_id);
			rs = pstmt.executeQuery();

			System.out.println("Order ID\tProduct Name\tProduct Quantity\tUnit Price\tProducer");
			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\n", rs.getString("order_id"),
						rs.getString("name"), rs.getString("quantity"), rs.getString("Unit Price"), rs.getString("business_name"));
			}
		} finally{
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	/**
	 *
	 */
	private void printEvents(String Region) throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_EVENTS);
			pstmt.setString(1, Region);
			rs = pstmt.executeQuery();

			System.out.println("Event Name\tDescription\tStart Date\tEnd Date\tLocation\tRegion");
			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\t%s\t%s\n", rs.getString("name"),
						rs.getString("description"), rs.getString("start_date"), rs.getString("end_date"), rs.getString("location"), rs.getString("region_name"));
			}
		} finally{
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	/**
	 *
	 */
	private void logout() {
		email = null;
		password = null;
	}





	/**
	 *
	 * @param user_psw
	 * @return true if the insert password 
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws IllegalStateException
	 */

	private Boolean checkPassword(String user_psw) throws SQLException, IllegalArgumentException, IllegalStateException , NoSuchAlgorithmException{

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String real_psw ="";

		try {
			pstmt = con.prepareStatement(SELECT_PSW);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			if(rs.next()){
				real_psw = rs.getString("password");
			}
			else {
				throw new IllegalStateException();
			}
			if(user_psw == null || !(user_psw instanceof String) || user_psw.length() == 0){
				throw new IllegalArgumentException("Incorrect argument passed to the function");
			}

			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(user_psw.getBytes());
			byte[] digest = md.digest();
			String myHash = DatatypeConverter.printHexBinary(digest).toLowerCase();

			if(myHash.equals(real_psw) ){
				return true;
			}else{
				return false;
			}
		}
		finally {
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	/**
	 *
	 * @param user_email user email to check
	 * @return true if user is registered, false otherwise
	 * @throws SQLException
	 */

	private Boolean checkIfUserExists(String user_email) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			pstmt = con.prepareStatement(EMAIL_CHECK);
			pstmt.setString(1, user_email);
			rs = pstmt.executeQuery();
			return rs.next();
		} finally {
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	/**
	 *
	 * @param user_email
	 * @return
	 * @throws SQLException
	 */

	private Boolean is_Customer(String user_email) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String user_role = "";

		try {
			pstmt = con.prepareStatement(ROLE);
			pstmt.setString(1,user_email);
			rs = pstmt.executeQuery();

			if(rs.next()){
				user_role = rs.getString("role");
			}

			if(user_role.equals("Customer")){
				return true;
			}
			else{
				return false;
			}
		} finally{
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	private Boolean is_Producer(String user_email) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String user_role = "";

		try {
			pstmt = con.prepareStatement(ROLE);
			pstmt.setString(1,user_email);
			rs = pstmt.executeQuery();

			if(rs.next()){
				user_role = rs.getString("role");
			}
			if(user_role == "Producer"){
				return true;
			}
			else{
				return false;
			}
		} finally{
			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		}
	}
	/**
	 * Run the whole simulation process
	 */
	private void runSimulation() throws IllegalArgumentException, IllegalStateException, NoSuchAlgorithmException {
		scan = new Scanner(System.in);

		connect();
		try {


			//Login

			/**
			 * Chiedere cosa vuole visualizzare l'utente tra:
			 * (Se Customer)
			 * - Mostrare gli ordini fatti
			 * - Mostrare un ordine in dettagli
			 * - Mostrare gli eventi futuri in una regione
			 *
			 * (Se Producer o Regional Manager)
			 * - Visualizzare le statistice di un producer
			 */

			//Logout

			//Login

			System.out.printf("Welcome!");
			System.out.printf("Please insert your email to login.\n");
			email = scan.nextLine();
			while(!checkIfUserExists(email)) {
				System.out.printf("Please insert a registered email.\n");
				email = scan.nextLine();
			}

			System.out.printf("Please insert your password.\n");
			String user_password = scan.nextLine();

			while(!checkPassword(user_password)) {
				System.out.printf("Please insert the correct password.\n");
				user_password = scan.nextLine();
			}

			if(is_Customer(email)){
				Boolean goodCommand = false;
				while(!goodCommand) {
					System.out.printf("Please what do you want to do?\n");
					System.out.printf("Digit 1 for visualize Order History\n");
					System.out.printf("Digit 2 for visualize a Order Detail\n");
					System.out.printf("Digit 3 for visualize a Future Events\n");
					System.out.printf("Digit q to logout\n");
					String choice = scan.nextLine();
					if(choice.equals("1")) {
						printOrders(email);
					} else if (choice.equals("2")) {
						System.out.printf("Insert your order ID\n");
						String order_id = scan.nextLine();
						printOrderDetail(order_id);
					} else if (choice.equals("3")) {
						System.out.printf("Insert the Region\n");
						String region = scan.nextLine();
						printEvents(region);
					} else if (choice.equals("q")) {
						logout();
						goodCommand = true;
					}
				}

			} else if(is_Producer(email)) {
				System.out.println("Xe un produtore!"); //TODO: remove
			}

		} catch (SQLException e) {
			System.out.println("Database access error:");

			// cycle in the exception chain
			while (e != null) {
				System.out.printf("- Message: %s%n", e.getMessage());
				System.out.printf("- SQL status code: %s%n", e.getSQLState());
				System.out.printf("- SQL error code: %s%n", e.getErrorCode());
				System.out.println();
				e = e.getNextException();
			}
		} finally {
			try {
				con.close();
			} catch (SQLException e) {
				System.out.printf("Could not close the connection to the database: %s.%n",
						e.getMessage());
			} finally {
				con = null;
			}
		}
	}

	/**
	 * Connect to the database
	 */
	private void connect() {
		try {
			Class.forName(DRIVER);
			System.out.printf("Driver %s successfully registered.%n", DRIVER);
		} catch (ClassNotFoundException e) {
			System.out.printf(
					"Driver %s not found: %s.%n", DRIVER, e.getMessage());
			System.exit(-1);
		}

		try {
			long time = -System.currentTimeMillis();
			con = DriverManager.getConnection(DATABASE, USER, PASSWORD);
			time += System.currentTimeMillis();

			System.out.printf("Connection to database %s successfully established in %,d milliseconds.%n",
					DATABASE, time);
		} catch (SQLException e) {
			System.out.printf("Could not connect to the database: %s%n", e.getMessage());
			System.exit(-2);
		}
	}
	/**
	 * The function that starts running the order simulation process
	 */
	public static void main(String args[]) throws IllegalArgumentException, IllegalStateException, NoSuchAlgorithmException {
		PrintOrder s = new PrintOrder();
		s.runSimulation();
	}
}
