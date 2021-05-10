using Caliburn.Micro;
using CourseManager.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CourseManager.Repository;

namespace CourseManager.ViewModels
{
    class MainViewModel :Screen
    {
        private const string _connectionString = @"Data Source=localhost;Initial Catalog=CourseReport;Integrated Security=True";
        private string _appStatus;

        private BindableCollection<CourseModel> _courses = new BindableCollection<CourseModel>();
        private BindableCollection<EnrollmentModel> _enrollments = new BindableCollection<EnrollmentModel>();
        private BindableCollection<StudentModel> _students = new BindableCollection<StudentModel>();

        private EnrollmentModel _selectedEnrollment;
        Command cmd = new Command(_connectionString);
        public MainViewModel()
        {
            SelectedEnrollment = new EnrollmentModel();

            try
            {
                
                Students.AddRange(cmd.GetList<StudentModel>("Student_GetList"));
                Courses.AddRange(cmd.GetList<CourseModel>("Course_GetList"));
                Enrollments.AddRange(cmd.GetList<EnrollmentModel>("Enrollment_GetList"));

            }
            catch (Exception ex)
            {
                AppStatus = ex.Message;
                NotifyOfPropertyChange(() => AppStatus);
            }
        }
        public void CreateEnrollment()
        {
            try
            {
                SelectedEnrollment = new EnrollmentModel();
                UpdateAppStatus("New enrollment created");
            }
            catch (Exception ex)
            {
                UpdateAppStatus(ex.Message);
            }
        }
        public void SaveEnrollment()
        {
            try
            {
                var enrollmentDic = Enrollments.ToDictionary(e => e.EnrollmentID);
                if(SelectedEnrollment!=null)
                {
                    cmd.UpSertEnrollment(SelectedEnrollment);
                    Enrollments.Clear();
                    Enrollments.AddRange(cmd.GetList<EnrollmentModel>("Enrollment_GetList"));
                    UpdateAppStatus("Saved");
                }
            }
            catch (Exception ex)
            {
                UpdateAppStatus(ex.Message);
            }
        }
        public CourseModel SelectedEnrollmentCourse {
            get
            {
                try
                {
                    var courseDictionary = Courses.ToDictionary(x => x.CourseID);
                    if (SelectedEnrollment != null && courseDictionary.ContainsKey(SelectedEnrollment.CourseID))
                        return courseDictionary[SelectedEnrollment.CourseID];
                }
                catch (Exception ex)
                {
                    UpdateAppStatus(ex.Message);
                }
                return null;
            }
            set
            {
                var selectedEnrollment = value;
                try
                {
                    SelectedEnrollment.CourseID = selectedEnrollment.CourseID;
                    NotifyOfPropertyChange(() => SelectedEnrollment);
                }
                catch (Exception ex)
                {
                    UpdateAppStatus(ex.Message);

                }
            }
            
        }
        public StudentModel SelectedEnrollmentStudent
        {
            get
            {
                try
                {
                    var studentDictionary = Students.ToDictionary(x => x.StudentID);
                    if (SelectedEnrollment != null && studentDictionary.ContainsKey(SelectedEnrollment.StudentID))
                        return studentDictionary[SelectedEnrollment.StudentID];
                }
                catch (Exception ex)
                {
                    UpdateAppStatus(ex.Message);
                }
                return null;
            }
            set
            {
                var selectedEnrollment = value;
                try
                {
                    SelectedEnrollment.StudentID= selectedEnrollment.StudentID;
                    NotifyOfPropertyChange(() => SelectedEnrollment);
                }
                catch (Exception ex)
                {
                    UpdateAppStatus(ex.Message);

                }
            }

        }



        public string AppStatus 
        {
            get { return _appStatus; }
            set {
                _appStatus = value;
                ;
            }
        }
        public void UpdateAppStatus(string message)
        {
            AppStatus = message;
            NotifyOfPropertyChange(() => AppStatus);
        }
        public BindableCollection<CourseModel> Courses
        {
            get { return _courses; }
            set { _courses = value; }
        }

        public BindableCollection<EnrollmentModel> Enrollments
        {
            get { return _enrollments; }
            set { _enrollments = value; }
        }

        public EnrollmentModel SelectedEnrollment
        {
            get { return _selectedEnrollment; }
            set
            {
                _selectedEnrollment = value;
                NotifyOfPropertyChange(() => SelectedEnrollment);
                NotifyOfPropertyChange(() => SelectedEnrollmentCourse);
                NotifyOfPropertyChange(() => SelectedEnrollmentStudent);
            }
        }
        public BindableCollection<StudentModel> Students
        {
            get { return _students; }
            set { _students = value; }
        }
    }
}
