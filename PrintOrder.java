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
	private static final String DATABASE = "jdbc:postgresql://dbstud/dbms1718?currentSchema=pasta";

	/**
	 * The username for accessing the database
	 */
	private static final String USER = "webdb";

	/**
	 * The password for accessing the database
	 */
	private static final String PASSWORD = "webdb";

	/**
	 * The statement to read the menus
	 */
	private static final String LIST_MENUS = "SELECT id, name, description "
			+ "FROM menu WHERE enabled is TRUE";

	/**
	 * The statement to print the dishes of a menu
	 */
	private static final String LIST_DISHES = "SELECT id, name, description, "
			+ "price::money::numeric::float8 "
			+ "FROM dish INNER JOIN belong1 ON id = dish_id WHERE menu_id = ?";

	/**
	 * The query to place the order
	 */
	private static final String PLACE_ORDER = "INSERT INTO Purchase "
			+ "(id, display_name, takeout, internet, n_clients, total, created_by) "
			+ "VALUES (?, ?, FALSE, FALSE, ?, ?, 'thomas')";

	/**
	 * The query to add dishes to the order
	 */
	private static final String DISH_ORDER = "INSERT INTO Contain "
			+ "(order_id, dish_id, quantity, applied_price) VALUES (?, ?, ?, ?)";

	/**
	 * The connection to the database
	 */
	private Connection con;

	/**
	 * The scanner to use to get data from the user
	 */
	private Scanner scan;

	/**
	 * The list of menu ids
	 *
	 * We have to check that the menu chosen by the user was printed in the
	 * list, so we keep this array with the prindted ids.
	 */
	private ArrayList<String> menuIds;

	/**
	 * The map of dish prices.
	 *
	 * We need to get the price of the dishes to populate the contain relation.
	 *	 
	 * We want to check the id of the dish to insert instead of making the query
	 * fail.
	 */
	private HashMap<String, BigDecimal> dishList;

	/**
	 * The map of chosen dish => quantity
	 */
	private HashMap<String, Short> ordered;

	/**
	 * The name of the customer
	 */
	private String name;

	/**
	 * The number of people in this order
	 */
	private int places;

	/**
	 * The total amount of the order
	 */
	BigDecimal total;

	/**
	 * Initializes variables
	 */
	private PrintOrder() {
		menuIds = new ArrayList<>();
		dishList = new HashMap<>();
		ordered = new HashMap<>();
		total = BigDecimal.ZERO;
	}

	/**
	 * Run the whole simulation process
	 */
	private void runSimulation() {
		scan = new Scanner(System.in);

		connect();
		try {
			System.out.printf("Here is the list of the menus:%n%n");
			printMenus();
			System.out.println();

			String chosenMenu = null;
			while (menuIds.indexOf(chosenMenu) == -1) {
				System.out.println("What menu do you want to use?");
				chosenMenu = scan.nextLine();

				if (menuIds.indexOf(chosenMenu) == -1) {
					System.out.println("The selected menu is not valid!");
				}
			}

			listDishes(chosenMenu);
			askDishes();

			if (!ordered.isEmpty()) {
				placeOrder();
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
	 * Print the list of enabled menus
	 *
	 * @throw SQLException if anything goes wrong while printing the list
	 */
	private void printMenus() throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(LIST_MENUS);

			System.out.println("Id\tName\tDescription");
			while (rs.next()) {
				System.out.printf("%s\t%s\t%s%n", rs.getString("id"),
						rs.getString("name"), rs.getString("description"));
				menuIds.add(rs.getString("id"));
			}
		} finally {
			if (rs != null) {
				rs.close();
			}

			if (stmt != null) {
				stmt.close();
			}
		}
	}

	/**
	 * List the dishes from a certain menu
	 *
	 * @param menuId the id of the menu to list the dishes from
	 * @throws SQLException if anything goes wrong while printing the list
	 */
	private void listDishes(String menuId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		System.out.println("Here are the dishes you can order:");
		System.out.println();

		try {
			pstmt = con.prepareStatement(LIST_DISHES);
			pstmt.setString(1, menuId);
			rs = pstmt.executeQuery();

			System.out.println("Id\tName\tPrice\tDescription");
			while (rs.next()) {
				System.out.printf("%s\t%s\t%.2f €\t%s%n", rs.getString("id"),
							rs.getString("name"), rs.getBigDecimal("price"),
							rs.getString("description"));
				dishList.put(rs.getString("id"), rs.getBigDecimal("price"));
			}
			System.out.println();
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
	 * Ask the user the dishes she/he wants to order
	 */
	private void askDishes() {
		System.out.println("Please insert all the dishes you want to order, one id and quantity per line.");
		System.out.println("To end an order, leave an empty line.");

		while(scan.hasNextLine()) {
			String line = scan.nextLine();

			if (line.isEmpty()) {
				break;
			}

			Scanner s = new Scanner(line);
			String dish = s.next();

			if (dishList.get(dish) == null || !s.hasNextInt()) {
				System.out.println("Invalid dish! Skipping line");
				s.close();
				continue;
			}

			short quantity = s.nextShort();
			s.close();

			if (quantity < 1) {
				System.out.println("Invalid quantity! Skipping line");
				continue;
			}

			Short old = ordered.get(dish);
			if (old != null) {
				quantity += old;
			}
			ordered.put(dish, quantity);
		}

		if (!ordered.isEmpty()) {
			System.out.println("Perfect, please new enter your name:");
			name = scan.nextLine();
			
			System.out.println("Finally, how many are you?");
			places = scan.nextInt();

			if (places < 1) {
				System.out.println("Invalid value, falling back to 1.");
				places = 1;
			}

			for (HashMap.Entry<String, Short> entry : ordered.entrySet()) {
				total = total.add(dishList.get(entry.getKey()).multiply(
						new BigDecimal(entry.getValue().shortValue())));
			}
			System.out.printf("Nice. The total of your order is %.2f€.%n", total);
		}
	}

	/**
	 * Put the order in the database
	 *
	 * @throw SQLException if anything goes wrong while placing the order
	 */
	private void placeOrder() throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(PLACE_ORDER);

			// Bad id but puttern, but this is just a demo
			String id = String.format("%d", System.currentTimeMillis());

			pstmt.setString(1, id);
			pstmt.setString(2, name);
			pstmt.setInt(3, places);
			pstmt.setBigDecimal(4, total);
			pstmt.execute();
			pstmt.close();

			pstmt = con.prepareStatement(DISH_ORDER);

			for (HashMap.Entry<String, Short> entry : ordered.entrySet()) {
				pstmt.setString(1, id);
				pstmt.setString(2, entry.getKey());
				pstmt.setShort(3, entry.getValue());
				pstmt.setBigDecimal(4, dishList.get(entry.getKey()));
				pstmt.addBatch();
			}

			pstmt.executeBatch();
			pstmt.close();
			pstmt = null;

			con.commit();

			System.out.println("Thank you! Order placed! You have been served by Thomas");
		} finally {
			if (pstmt != null) {
				pstmt.close();
			}

			con.setAutoCommit(true);
		}
	}

	/**
	 * The function that starts running the order simulation process
	 */
	public static void main(String args[]) {
		PrintOrder s = new PrintOrder();
		s.runSimulation();
	}
}
