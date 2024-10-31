import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TesteConexao {
    private static final String URL = "jdbc:postgresql://localhost:5432/bd_aula";
    private static final String USER = "postgres";
    private static final String PASSWORD = "PA@password";

    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement stm = null;

        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            conn.setAutoCommit(false);

            if (conn != null) {
                String sql = "INSERT INTO usuarios(nome, email) VALUES (?, ?)";

                // Primeira operação
                stm = conn.prepareStatement(sql);
                stm.setString(1, "jaca");
                stm.setString(2, "jaca@gmail.com");
                stm.executeUpdate();

                // Segunda operação
                stm.setString(1, "juca");
                stm.setString(2, "juca@gmail.com");
                stm.executeUpdate();

                conn.commit();

                System.out.println("PROGRAMA FOI EXECUTADO");
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (stm != null) {
                    stm.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
