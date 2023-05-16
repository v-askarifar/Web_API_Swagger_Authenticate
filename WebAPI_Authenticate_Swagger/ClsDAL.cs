using Microsoft.Web.Administration;
using System.Data;
using System.Data.SqlClient;
using System.Formats.Asn1;

namespace WebAPI_Authenticate_Swagger
{
    public class ClsDAL
    {
        //public static string ConnectionString = Configuration.GetConnectionString("MasterDatabase");

        private string getConnectionString()
        {
            return "Data Source=.;Initial Catalog=Authenticate ;Persist Security Info=True;User ID=sa;PASSWORD=123";
        }

        public DataTable AuthenticateUser(string Username, string Password)
        {


            DataTable ret = null;

            DataTable dt = new DataTable();
            SqlConnection conn = new SqlConnection(getConnectionString());
            conn.Open();
            SqlCommand dCmd = new SqlCommand("SPAuthenticateUserMobile", conn);
            dCmd.CommandType = CommandType.StoredProcedure;
            IDataReader reader;
            
            try
            {
                dCmd.Parameters.AddWithValue("@txt_UserName", Username);
                dCmd.Parameters.AddWithValue("@txt_Password", Password);
                
                reader = dCmd.ExecuteReader();
                dt.Load(reader);

                try
                {
                    reader.Close();
                }
                catch { }
                try
                {
                    reader.Dispose();
                }
                catch { }

                ret = dt;
                return dt;
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {

                dt.Dispose();
                dCmd.Dispose();
                ret.Dispose();
                conn.Close();
                conn.Dispose();
            }


            return ret;
        }

        public DataTable CountInvalidLogin(string ReqDate, string ReqIP, string ReqUser)
        {
            DataTable dt = new DataTable();
            SqlConnection conn = new SqlConnection(getConnectionString());
            conn.Open();
            SqlCommand dCmd = new SqlCommand("SPCountInvalidLoginMobile", conn);
            dCmd.CommandType = CommandType.StoredProcedure;
            IDataReader reader;
            try
            {
                dCmd.Parameters.AddWithValue("@ReqDate", ReqDate);
                dCmd.Parameters.AddWithValue("@ReqIP", ReqIP);
                dCmd.Parameters.AddWithValue("@ReqUser", ReqUser);
                reader = dCmd.ExecuteReader();
                dt.Load(reader);

                try
                {
                    reader.Close();
                }
                catch { }
                try
                {
                    reader.Dispose();
                }
                catch { }
                return dt;
            }
            catch
            {
                throw;
            }
            finally
            {

                dt.Dispose();
                dCmd.Dispose();

                conn.Close();
                conn.Dispose();
            }
        }

        public void NewLogFailedLogin(string LFL_USER, string LFL_PASS, string LFL_DATETIME, string LFL_STATUS, string LFL_IP, string LFL_OS, string LFL_BROWSER)
        {
            SqlConnection conn = new SqlConnection(getConnectionString());
            conn.Open();//SPNewLogFailedLogin
            SqlCommand dCmd = new SqlCommand("SPNewLogFailedLogin", conn);
            dCmd.CommandType = CommandType.StoredProcedure;
            dCmd.Parameters.AddWithValue("@LFL_USER", LFL_USER);
            dCmd.Parameters.AddWithValue("@LFL_PASS", LFL_PASS);
            dCmd.Parameters.AddWithValue("@LFL_DATETIME", LFL_DATETIME);

            dCmd.Parameters.AddWithValue("@LFL_STATUS", LFL_STATUS);
            dCmd.Parameters.AddWithValue("@LFL_IP", LFL_IP);
            dCmd.Parameters.AddWithValue("@LFL_OS", LFL_OS);
            dCmd.Parameters.AddWithValue("@LFL_BROWSER", LFL_BROWSER);
            try
            {
                dCmd.ExecuteNonQuery();
            }
            catch
            {
                throw;
            }
            finally
            {
                dCmd.Dispose();
                conn.Close();
                conn.Dispose();
            }
        }


        public void NewToken(string UserID, string UserName, string Info, DateTime ExpireDate, DateTime CreateDate, string Token)
        {
            SqlConnection conn = new SqlConnection(getConnectionString());
            conn.Open();//SPNewLogFailedLogin
            SqlCommand dCmd = new SqlCommand("SPNewToken", conn);

            dCmd.CommandType = CommandType.StoredProcedure;
            dCmd.Parameters.AddWithValue("@UserID", UserID);
            dCmd.Parameters.AddWithValue("@UserName", UserName);
            dCmd.Parameters.AddWithValue("@Info", Info);

            dCmd.Parameters.AddWithValue("@ExpireDate", ExpireDate);
            dCmd.Parameters.AddWithValue("@CreateDate", CreateDate);
            dCmd.Parameters.AddWithValue("@Token", Token);


            try
            {
                dCmd.ExecuteNonQuery();
            }
            catch
            {
                throw;
            }
            finally
            {
                dCmd.Dispose();
                conn.Close();
                conn.Dispose();
            }
        }

        public DataTable isValidToken(string Token)
        {

            DataTable dt = new DataTable();
            SqlConnection conn = new SqlConnection(getConnectionString());
            conn.Open();
            SqlCommand dCmd = new SqlCommand("SPLoadToken", conn);
            dCmd.CommandType = CommandType.StoredProcedure;
            IDataReader reader;
            try
            {
                dCmd.Parameters.AddWithValue("@Token", Token);
                dCmd.Parameters.AddWithValue("@DateNow", DateTime.Now);

                reader = dCmd.ExecuteReader();
                dt.Load(reader);
                try
                {
                    reader.Close();
                }
                catch { }
                try
                {
                    reader.Dispose();
                }
                catch { }
                return dt;
            }
            catch
            {
                throw;
            }
            finally
            {

                dt.Dispose();
                dCmd.Dispose();

                conn.Close();
                conn.Dispose();
            }
        }
        

    }
}
