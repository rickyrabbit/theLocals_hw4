import javax.xml.bind.DatatypeConverter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.Scanner;

/**
 * Simulate typical user (Customer and Producer) actions, through a textual interface
 */
public class UserActions {

	/**
	 * The JDBC driver to be used
	 */
	private static final String DRIVER = "org.postgresql.Driver";

	/**
	 * The URL of the database to be accessed
	 */
	private static final String DATABASE = "jdbc:postgresql://localhost/localproductions";

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
	 * The statement to list the last 15 orders received by a producer
	 */
	private static final String LIST_PRODUCER_ORDERS = "SELECT o.order_id, o.order_timestamp, o.total_price, m.type FROM Make AS m "
			+ "INNER JOIN Orders AS o ON m.order_id = o.order_id "
			+ "WHERE producer_email = ? "
			+ "ORDER BY order_id DESC "
			+ "LIMIT 15; ";

	/**
	 * The statement to list the details of an customer order
	 */
	private static final String LIST_ORDER_DETAIL = "SELECT c.order_id, p.product_code, name, quantity, price AS \"Unit Price\", business_name FROM Contain as c "
			+ "INNER JOIN Make AS m On c.order_id = m.order_id "
			+ "INNER JOIN Product AS p ON c.product_code = p.product_code "
			+ "INNER JOIN Producer AS prdcr ON m.producer_email = prdcr.email "
			+ "WHERE c.order_id::varchar = ? AND m.customer_email = ? "
			+ "ORDER BY name ASC; ";

	/**
	 * The statement to list the details of an producer order
	 */
	private static final String LIST_PRODUCER_ORDER_DETAIL = "SELECT c.order_id, p.product_code, name, quantity, price AS \"Unit Price\", business_name FROM Contain as c "
			+ "INNER JOIN Make AS m On c.order_id = m.order_id "
			+ "INNER JOIN Product AS p ON c.product_code = p.product_code "
			+ "INNER JOIN Producer AS prdcr ON m.producer_email = prdcr.email "
			+ "WHERE c.order_id::varchar = ? AND m.producer_email = ? "
			+ "ORDER BY name ASC; ";

	/**
	 * The statement to list the future events that will take place in a region
	 */
	private static final String LIST_EVENTS = "SELECT DISTINCT e.event_id, e.name, description, start_date, end_date, location, region_name FROM Event AS e "
			+ "WHERE end_date >= CURRENT_DATE AND region_name = ?; ";

	/**
	 * The statement to list the 5 most sold product by a producer
	 */
	private static final String LIST_PRODUCER_STATS = "SELECT c.product_code, p.name, SUM(c.quantity) AS \"Total Sell\" FROM Make AS m "
			+ "INNER JOIN Orders AS o ON m.order_id = o.order_id "
			+ "INNER JOIN Contain AS c ON m.order_id = c.order_id "
			+ "INNER JOIN Product AS p ON p.product_code = c.product_code "
			+ "WHERE m.producer_email = ? AND o.order_status = 'Completed' "
			+ "GROUP BY c.product_code, p.name "
			+ "ORDER BY \"Total Sell\" DESC "
			+ "LIMIT 5; ";

	/**
	 * The statement to retrieve an End User by email
	 */
	private static final String EMAIL_CHECK = "SELECT * FROM End_User WHERE email = ?;";

	/**
	 * The statement to select the End User password by email
	 */
	private static final String SELECT_PSW = "SELECT password FROM End_User WHERE email = ?;";

	/**
	 * The statement to list the End User rose by email
	 */
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
	 * The logged in user mail
	 */

	private String email;

	/**
	 * The logged in user password (md5)
	 */

	private String password;

	/**
	 * The method for printing the user orders
	 */
	private void printCustomerOrders() throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_ORDERS);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();

			System.out.println("Order ID\tOrder Timestamp\tTotal Price\tPayment Method");

			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\n",
						rs.getString("order_id"),
						rs.getString("order_timestamp"),
						rs.getString("total_price"),
						rs.getString("type"));
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
	 * The method that prints the details of the order made by a customer selected by id
	 * @param order_id the id of the order to print
	 */
	private void printCustomerOrderDetail(String order_id) throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_ORDER_DETAIL);
			pstmt.setString(1, order_id);
			pstmt.setString(2, email);
			rs = pstmt.executeQuery();

			if (!rs.isBeforeFirst()){
				System.out.println("You don't have order with the provided ID, please retry.");
			} else {
				System.out.println("Order ID\tProduct Name\tProduct Quantity\tUnit Price\tProducer");
			}

			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\t%s\n",
						rs.getString("order_id"),
						rs.getString("name"),
						rs.getString("quantity"),
						rs.getString("Unit Price"),
						rs.getString("business_name"));
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
	 *	The method for printing the current or future events that take place in a region
	 */
	private void printEvents(String Region) throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_EVENTS);
			pstmt.setString(1, Region);
			rs = pstmt.executeQuery();

			if (!rs.isBeforeFirst()){
				System.out.println("There aren't scheduled events in "+Region+". :'(");
			} else {
				System.out.println("Event Name\tDescription\tStart Date\tEnd Date\tLocation\tRegion");
			}

			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\t%s\t%s\n",
						rs.getString("name"),
						rs.getString("description"),
						rs.getString("start_date"),
						rs.getString("end_date"),
						rs.getString("location"),
						rs.getString("region_name"));
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
	 * Method to logout the current user
	 */
	private void logout() {
		email = null;
		password = null;
	}

	/**
	 *	The method for printing the 5 most sold product by a producer
	 */
	private void printStats() throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_PRODUCER_STATS);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();

			System.out.println("Product Code\tProduct Name\tTotal Sell");

			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\n",
						rs.getString("product_code"),
						rs.getString("name"),
						rs.getString("Total Sell"));
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
	 * The method for printing the orders received by the producer
	 */
	private void printProducerOrders() throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_PRODUCER_ORDERS);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();

			System.out.println("Order ID\tOrder Timestamp\tTotal Price\tPayment Method");

			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\n",
						rs.getString("order_id"),
						rs.getString("order_timestamp"),
						rs.getString("total_price"),
						rs.getString("type"));
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
	 * The method that prints the details of a order received by a producer selected by id
	 * @param order_id
	 */
	private void printProducerOrderDetail(String order_id) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			pstmt = con.prepareStatement(LIST_PRODUCER_ORDER_DETAIL);
			pstmt.setString(1, order_id);
			pstmt.setString(2, email);
			rs = pstmt.executeQuery();

			if (!rs.isBeforeFirst()){
				System.out.println("You don't have received order with the provided ID, please retry.");
			} else {
				System.out.println("Order ID\tProduct Name\tProduct Quantity\tUnit Price\tProducer");
			}

			while (rs.next()) {
				System.out.printf("%s\t%s\t%s\t%s\n", rs.getString("order_id"),
						rs.getString("name"), rs.getString("quantity"),
						rs.getString("Unit Price"), rs.getString("business_name"));
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
	 * The method that checks if the password inserted by the user is correct and correspond to the one saved in the database.
	 * @param user_psw the password inserted by the user
	 * @return true if the insert password
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws IllegalStateException
	 */
	private Boolean checkPassword(String user_psw) throws SQLException, IllegalArgumentException, IllegalStateException , NoSuchAlgorithmException{

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String real_psw;

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
				password = real_psw;
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
	 * The method that checks if an user with a certain email exists
	 * @return true if user is registered, false otherwise
	 * @throws SQLException
	 */
	private Boolean checkIfUserExists() throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			pstmt = con.prepareStatement(EMAIL_CHECK);
			pstmt.setString(1, email);
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
	 * The method that check if the logged in user is a customer
	 * @return true if the logged in user is a customer
	 * @throws SQLException
	 */
	private Boolean is_Customer() throws SQLException {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String user_role = "";

		try {
			pstmt = con.prepareStatement(ROLE);
			pstmt.setString(1, email);
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

	/**
	 * The method that check if the logged in user is a producer
	 * @return true if the logged in user is a producer
	 * @throws SQLException
	 */
	private Boolean is_Producer() throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String user_role = "";

		try {
			pstmt = con.prepareStatement(ROLE);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();

			if(rs.next()){
				user_role = rs.getString("role");
			}
			if(user_role.equals("Producer")){
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
			System.out.printf("Welcome!");
			System.out.printf("Please insert your email to login.\n");
			email = scan.nextLine();
			while(!checkIfUserExists()) {
				System.out.printf("Please insert a registered email.\n");
				email = scan.nextLine();
			}

			System.out.printf("Please insert your password.\n");
			String user_password = scan.nextLine();

			while(!checkPassword(user_password)) {
				System.out.printf("Please insert the correct password.\n");
				user_password = scan.nextLine();
			}

			Boolean loggedOut = false;

			if(is_Customer()){
				while(!loggedOut) {
					System.out.printf("\nWhat do you want to do?\n");
					System.out.printf("Digit 1 for visualize Order History\n");
					System.out.printf("Digit 2 for visualize a Order Details\n");
					System.out.printf("Digit 3 for visualize a Future Events\n");
					System.out.printf("Digit q to logout\n");
					String choice = scan.nextLine();
					if(choice.equals("1")) {
						printCustomerOrders();
					} else if (choice.equals("2")) {
						System.out.printf("Insert your order ID\n");
						String order_id = scan.nextLine();
						printCustomerOrderDetail(order_id);
					} else if (choice.equals("3")) {
						System.out.printf("Insert the Region\n");
						String region = scan.nextLine();
						printEvents(region);
					} else if (choice.equals("q")) {
						logout();
						loggedOut = true;
					}
				}
			} else if(is_Producer()) {
				while(!loggedOut) {
					System.out.printf("\nWhat do you want to do?\n");
					System.out.printf("Digit 1 for visualize your sell stats\n");
					System.out.printf("Digit 2 for visualize last 15 orders you received\n");
					System.out.printf("Digit 3 for visualize a Order Details\n");
					System.out.printf("Digit q to logout\n");
					String choice = scan.nextLine();
					if(choice.equals("1")) {
						printStats();
					} else if (choice.equals("2")) {
						printProducerOrders();
					} else if (choice.equals("3")) {
						System.out.printf("Insert the order ID\n");
						String order_id = scan.nextLine();
						printProducerOrderDetail(order_id);
					} else if (choice.equals("q")) {
						logout();
						loggedOut = true;
					}
				}
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

			System.out.printf("Connection to database %s successfully established in %,d milliseconds.%n", DATABASE, time);
		} catch (SQLException e) {
			System.out.printf("Could not connect to the database: %s%n", e.getMessage());
			System.exit(-2);
		}
	}

	/**
	 * The function that starts running the order simulation process
	 */
	public static void main(String args[]) throws IllegalArgumentException, IllegalStateException, NoSuchAlgorithmException {
		UserActions ua = new UserActions();
		ua.runSimulation();
	}
}
