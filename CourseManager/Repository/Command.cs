using CourseManager.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CourseManager.Repository
{
    class Command
    {
        private string _connectionString;
        public Command(string connectionString)
        {
            _connectionString = connectionString;
        }
        public IList<T> GetList<T>(string sqlProcedureOrView)
        {
            List<T> list;
            Type type = typeof(T);
            using (SqlConnection sql = new SqlConnection(_connectionString))
            {
                list = sql.Query<T>(sqlProcedureOrView).ToList();
            }

            if(typeof(T) == typeof(EnrollmentModel))
            {
                List<EnrollmentModel> ems = list as List<EnrollmentModel>;
                foreach (var em in ems)
                    em.IsCommited = true;
                
            }
            return list;
        }
        public void UpSertEnrollment(EnrollmentModel em)
        {
            string userId = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            string sqlCommand = "Enrollment_Upsert";

            var dataTable = new DataTable();
            dataTable.Columns.Add("EnrollmentID", typeof(int));
            dataTable.Columns.Add("StudentID", typeof(int));
            dataTable.Columns.Add("CourseID", typeof(int));
            dataTable.Rows.Add(em.EnrollmentID, em.StudentID, em.CourseID);

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Execute(sqlCommand, new { @EnrollmentType = dataTable.AsTableValuedParameter("EnrollmentType"), @UserID = userId }, commandType: CommandType.StoredProcedure);
                
            }
        }
    }
}
