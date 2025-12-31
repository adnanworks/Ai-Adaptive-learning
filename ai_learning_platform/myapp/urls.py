"""ai_learning_platform URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path, include
from myapp import views

urlpatterns = [
    path('logouts/',views.logouts),

    path('',views.index),
    path('login_get/',views.login_get),
    path('login_post/',views.login_post),
    path('admin_home/',views.admin_home),
    path('admin_view_staff_get/',views.admin_view_staff_get),
    path('admin_verify_staff_post/',views.admin_verify_staff_post),

    path('add_students_get/',views.add_students_get),
    path('add_student_post/',views.add_student_post),
    path('view_students_get/',views.view_students_get),
    path('admin_edit_student_get/<id>',views.admin_edit_student_get),
    path('editstudent_post/',views.editstudent_post),
    path('admin_delete_student_get/<id>',views.admin_delete_student_get),

    path('add_subjects_get/',views.add_subjects_get),
    path('add_subject_post/',views.add_subject_post),
    path('view_subjects_get/',views.view_subjects_get),
    path('editsubject_get/<id>',views.editsubject_get),
    path('editsubject_post/',views.editsubject_post),
    path('delete_subject/<id>',views.delete_subject),

    path('assign_subjects_get/',views.assign_subjects_get),
    path('assignsubjects_post/',views.assignsubjects_post),
    path('view_assignedsubjects/',views.view_assignedsubjects),
    path('editassigned_get/<id>',views.editassigned_get),
    path('editassigned_post/',views.editassigned_post),
    path('delete_assigned/<id>',views.delete_assigned),

    path('view_feedback_admin/',views.view_feedback_admin),
    path('admin_view_complaints/',views.admin_view_complaints),
    path('admin_compl_reply_get/<id>', views.admin_compl_reply_get),
    path('admin_compl_reply_post/', views.admin_compl_reply_post),

    path('send_notification_admin/',views.send_notification_admin),
    path('add_notification_post/',views.add_notification_post),
    path('view_notification_admin/',views.view_notification_admin),
    path('delete_notofication/<id>',views.delete_notofication),

    path('changepwd_admin_get/',views.changepwd_admin_get),
    path('changepwd_admin_post/',views.changepwd_admin_post),

# ================================staff==============================

    path('staff_register_get/',views.staff_register_get),
    path('staff_register_post/',views.staff_register_post),
    path('staff_home/',views.staff_home),
    path('staff_viewprofile/',views.staff_viewprofile),
    path('staff_edit_profile_get/<id>',views.staff_edit_profile_get),
    path('staff_edit_profile_post/',views.staff_edit_profile_post),

    path('staffview_subjects_get/',views.staffview_subjects_get),
    path('add_matierial_get/',views.add_matierial_get),
    path('add_matierial_post/',views.add_matierial_post),
    path('view_studymaterial/',views.view_studymaterial),
    path('edit_material_get/<id>',views.edit_material_get),
    path('edit_material_post/',views.edit_material_post),
    path('delete_studymaterial/<id>',views.delete_studymaterial),

    path('staffview_notific/',views.staffview_notific),

    path('staffadd_exam_get/',views.staffadd_exam_get),
    path('add_test_post/',views.add_test_post),
    path('staff_view_exam_get/',views.staff_view_exam_get),
    path('delete_exam/<id>',views.delete_exam),

    path('staffadd_qstn_get/<id>',views.staffadd_qstn_get),
    path('add_question_post/',views.add_question_post),
    path('staffview_qstn_get/<id>',views.view_questions),
    path('delete_question/<id>',views.delete_question),

    path('staffview_result/',views.staffview_result),

    path('staff_view_students_get/',views.staff_view_students_get),
    path('staffview_doubt_get/',views.staffview_doubt_get),
    path('staff_doubt_reply_get/<id>',views.staff_doubt_reply_get),
    path('staff_doubt_reply_post/',views.staff_doubt_reply_post),

    path('staff_change_pwd_get/',views.staff_change_pwd_get),

# ================================student==============================


    path('student_login/', views.student_login),
    path('std_viewprofile/', views.std_viewprofile),
    path('student_viewstaff/', views.student_viewstaff),
    path('ask_doubt/', views.ask_doubt),
    path('student_view_reply/', views.student_view_reply),

    path('send_complaint/', views.send_complaint),
    path('std_viewcomplaint/', views.std_viewcomplaint),

    path('send_feedback/', views.send_feedback),
    path('student_viewsubject/', views.student_viewsubject),
    path('student_viewstudymaterial/', views.student_viewstudymaterial),

    path('student_viewnotif/', views.student_viewnotif),

    path('student_viewexam/', views.student_viewexam),
    path('user_view_question_get/', views.student_view_questions),
    path('submit_answer/', views.submit_answer),

    path('student_view_results/', views.student_view_results),

    path('recommended_notes/', views.recommended_notes),

    path('chatbot_recommend_notes/', views.chatbot_recommend_notes),

    path('std_changepassword/', views.std_changepassword),

]
