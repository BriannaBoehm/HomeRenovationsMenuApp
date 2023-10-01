//HomeRenovationsMenuApp communicates with a database to keep track of the details of varioius home renovations. The user can add new projects, input materials, update instructions, and more! 
//Java is the primary language used for this project. A dependency on MySQL is added. 
//The method insertProject in the projectDAO layer makes textbook use of prepared statements to protect against SQL injection attacks. 
	public Project insertProject(Project project) {
		//@formatter:off 
		String sql = " " //this sql String gives the sql lanugage that will be used to communicate with the database 
		+ "INSERT INTO " + PROJECT_TABLE + "" 
		+ "(project_name, estimated_hours, actual_hours, difficulty, notes) "
		+ "VALUES "
		+ "(?, ?, ?, ?, ?)"; //? is a placeholder for sql 
		//@formatter:on

		try (Connection conn = DbConnection.getConnection()) {// a connection is established
			startTransaction(conn); // the transaction is started

			try (PreparedStatement stmt = conn.prepareStatement(sql)) {

				setParameter(stmt, 1, project.getProjectName(), String.class); // setParameter is a convenience method
																				// that allows us to set the various
																				// parameters
				setParameter(stmt, 2, project.getEstimatedHours(), BigDecimal.class);
				setParameter(stmt, 3, project.getActualHours(), BigDecimal.class);
				setParameter(stmt, 4, project.getDifficulty(), Integer.class);
				setParameter(stmt, 5, project.getNotes(), String.class);

				stmt.executeUpdate();
				Integer projectId = getLastInsertId(conn, PROJECT_TABLE);
				commitTransaction(conn);

				project.setProjectId(projectId);
				return project;

			} catch (Exception e) { // an exception is caught if it appears and the connection is rolledback before
									// the exception is thrown to the user
				rollbackTransaction(conn);
				throw new DbException(e);
			}
		} catch (SQLException e) {
			throw new DbException(e);
		}
	}

 //The method fetchAllProjects uses SQL statements to call to the database and return all created projects. 

 	public static List<Project> fetchAllProjects() {
		String sql = "SELECT * FROM " + PROJECT_TABLE + " ORDER BY project_name";
		try (Connection conn = DbConnection.getConnection();) {
			startTransaction(conn);// made startTransaction into static to avoid compilation error

			try (PreparedStatement stmt = conn.prepareStatement(sql)) {

				try (ResultSet rs = stmt.executeQuery()) {
					List<Project> listOfProjects = new LinkedList<>();

					while (rs.next()) {
						listOfProjects.add(extract(rs, Project.class)); // made method static in DaoBase to avoid
																		// compilation error
					}
					return listOfProjects;
				}

			} catch (Exception e) {
				rollbackTransaction(conn);
				throw new DbException(e);
			}
		} catch (SQLException e) {
			throw new DbException(e);
		}

	}

 //Please contact me with any questions! I can be reached at brianna.d.boehm@gmail.com 
 
