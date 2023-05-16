using Microsoft.AspNetCore.Mvc;
using Microsoft.Web.Administration;
using System.Data;
using Microsoft.AspNetCore.Http.Features;
using System.Formats.Asn1;

namespace WebAPI_Authenticate_Swagger.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AuthenticateController : ControllerBase
    {
 

        private readonly ILogger<AuthenticateController> _logger;

        public AuthenticateController(ILogger<AuthenticateController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "AuthenticateUser")]
        public string Get(string username,string password)
        {
            string ret = "";
            
            DataTable dt = new DataTable();
            ClsDAL cls1 = new ClsDAL();
            try
            {
                //HttpContextAccessor.HttpContext.Connection.RemoteIpAddress.ToString()


                var address = HttpContext.Connection.RemoteIpAddress.ToString();


                dt = cls1.AuthenticateUser(username, password);



                dt.TableName = "dt";

                if (isLockIpInLogin(address, username) == true)
                {
                    throw new System.InvalidOperationException(" your ip is block : " + address);
                }
                else if (dt == null)
                {
                    ret = "2,0,0,0";
                    NewLogFailedLogin(username, password, getDateTime(DateTime.Now), "0", address, "Mobile App", "");
                   
                    throw new System.InvalidOperationException("null DataTable");
                }
                else if (dt.Rows.Count <= 0)
                {
                    ret = "2,0,0,0";
                    NewLogFailedLogin(username, password, getDateTime(DateTime.Now), "0", address, "Mobile App", "");
                    throw new System.InvalidOperationException("not exist User");
                }
                else
                {
                    Guid id = Guid.NewGuid();
                    string USERS_UID = dt.Rows[0]["USERS_UID"].ToString();
                    cls1.NewToken(USERS_UID, username, "", DateTime.Now.AddDays(1), DateTime.Now, id.ToString());
                    ret = "1," + id.ToString();
                    return ret;
                }


            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                cls1 = null;
            }
        }

        private bool isLockIpInLogin(string _ip, string _user)
        {
            bool ret = true;
            ClsDAL cls1 = new ClsDAL();

            
            try
            {
                DataTable dt = cls1.CountInvalidLogin(getDateTime(DateTime.Now), _ip, _user);


                if (Convert.ToInt32(dt.Rows[0]["Result"].ToString()) >= 5)
                {

                    ret = true;
                }
                else
                {
                    ret = false;
                }

            }
            catch (Exception ex) {  }
            finally
            {
                cls1 = null;
            }


            return ret;
        }


        private string leftZiro(string num)
        {
            string ret = num;
            if (num.Length == 1)
            {
                ret = "0" + num;
            }

            return ret;

        }

        private string getDateTime(DateTime _dt)
        {
            return _dt.Year.ToString() + leftZiro(_dt.Month.ToString()) + leftZiro(_dt.Day.ToString()) + leftZiro(_dt.Hour.ToString()) + leftZiro(_dt.Minute.ToString()) + leftZiro(_dt.Second.ToString());
        }

        private void NewLogFailedLogin(string LFL_USER, string LFL_PASS, string LFL_DATETIME, string LFL_STATUS, string LFL_IP, string LFL_OS, string LFL_BROWSER)
        {
            ClsDAL cls1 = new ClsDAL();
            try
            {
                cls1.NewLogFailedLogin(LFL_USER, LFL_PASS, LFL_DATETIME, LFL_STATUS, LFL_IP, LFL_OS, LFL_BROWSER);
            }
            catch
            {
                throw;
            }
            finally
            {
                cls1 = null;
            }
        }


        private bool isValidToken(string token)
        {

            bool ret = false;

            try
            {
                ClsDAL cls1 = new ClsDAL();
                DataTable dt = new DataTable();

                dt = cls1.isValidToken(token);
                dt.TableName = "dt";

                if (dt.Rows.Count > 0)
                {
                    ret = true;
                }

            }
            catch (Exception ex) { ret = false; }

            return ret;
        }
    }
}