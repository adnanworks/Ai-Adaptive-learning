import json
from datetime import date
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User, Group
from django.core.files.storage import FileSystemStorage

from django.db.models import Q
from django.http import JsonResponse, HttpResponse
from django.shortcuts import render, redirect


# Create your views here.
from myapp.models import *




def logouts(request):
    logout(request)
    return redirect('/myapp/login_get/')

def index(request):
    return render(request,'index.html')



def login_get(request):
    return render(request,'login.html')


def login_post(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        user = authenticate(request, username=username, password=password)
        if user is not None:
            print("hhh")
            if user.groups.filter(name="admin").exists():
                print("jajaja")
                login(request,user)
                return redirect('/myapp/admin_home/')
            elif user.groups.filter(name="staff").exists():
                s = Staff.objects.get(LOGIN_id=user.id)
                print(user.id,'user')
                if s.status == 'Active':
                    login(request, user)
                    return redirect('/myapp/staff_home/')
                elif s.status == 'Blocked':
                    print("not act")
                    messages.error(request, "Id is not active, Contact Admin")
                    return redirect('/myapp/login_get/')


        else:
            messages.error(request, "Invalid username or password")
            print("helloooo")
            return redirect('/myapp/login_get/')


@login_required(login_url='/myapp/login_get/')
def admin_home(request):
    return render(request,'admin/home.html')

@login_required(login_url='/myapp/login_get/')
def admin_view_staff_get(request):
    s=Staff.objects.all()
    return render(request, 'admin/view_staff.html',{'data':s})


def admin_verify_staff_post(request):
    if request.method=='POST':
        if 'unblock' in request.POST:
            id=request.POST.get('unblock')
            i=Staff.objects.get(id=id)
            i.status='Active'
            i.save()
            messages.success(request, 'Accepted')
            return redirect('/myapp/admin_view_staff_get/')
        elif 'block' in request.POST:
            id = request.POST.get('block')
            i = Staff.objects.get(id=id)
            i.status = 'Blocked'
            i.save()
            messages.success(request, 'Blocked')
            return redirect('/myapp/admin_view_staff_get/')


@login_required(login_url='/myapp/login_get/')
def add_students_get(request):

    return render(request, 'admin/add_students.html',{'today': date.today().isoformat()})

def add_student_post(request):
    name=request.POST['name']
    email = request.POST['email']
    place = request.POST['place']
    dob=request.POST['dob']
    phone = request.POST['phone']
    sem=request.POST['sem']
    photo = request.FILES['photo']
    fs = FileSystemStorage()
    path=fs.save(photo.name,photo)

    if User.objects.filter(username=email).exists():
        messages.error(request, 'Email id already exists.')
        return redirect('/myapp/add_students_get/')
    else:

        user = User.objects.create_user(username=email, password=phone, email=email)
        user.save()
        user.groups.add(Group.objects.get(name='student'))

        s=Student()
        s.name=name
        s.email=email
        s.place=place
        s.dob=dob
        s.phone=phone
        s.semester=sem
        s.photo=path
        s.LOGIN=user
        s.save()
        messages.success(request, 'Registration successful for students! can login now.')
        return redirect('/myapp/view_students_get/')

@login_required(login_url='/myapp/login_get/')
def view_students_get(request):
    s = Student.objects.all()
    return render(request, 'admin/view_student.html',{'data':s})

@login_required(login_url='/myapp/login_get/')
def admin_edit_student_get(request,id):
    i = Student.objects.get(id=id)
    return render(request, 'admin/edit_student.html',{'i':i})

def editstudent_post(request):
    id = request.POST['id']
    i = Student.objects.get(id=id)
    name = request.POST['name']
    email = request.POST['email']
    place = request.POST['place']
    dob = request.POST['dob']
    phone = request.POST['phone']
    sem = request.POST['sem']

    user = i.LOGIN
    user.email = email
    user.password=make_password(phone)
    user.username = email
    user.save()

    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs=FileSystemStorage()
        path = fs.save(photo.name, photo)
        i.photo = path
        i.save()

    i.name=name
    i.email = email
    i.place=place
    i.dob = dob
    i.phone=phone
    i.semester=sem
    i.semester=sem
    i.save()
    print('ssss',i)
    messages.success(request, 'Student details edited')
    return redirect('/myapp/view_students_get/')


def admin_delete_student_get(request,id):
    i = Student.objects.get(id=id)
    i.delete()
    messages.success(request, 'Student deleted')
    return redirect('/myapp/view_students_get/')


@login_required(login_url='/myapp/login_get/')
def add_subjects_get(request):
    return render(request, 'admin/add_subjects.html')

def add_subject_post(request):
    name=request.POST['name']
    sem=request.POST['sem']

    s=Subjects()
    s.subname=name
    s.semester=sem
    s.save()
    messages.success(request, 'Subject Added')
    return redirect('/myapp/view_subjects_get/')

@login_required(login_url='/myapp/login_get/')
def view_subjects_get(request):
    s = Subjects.objects.all()
    return render(request, 'admin/view_subject.html',{'data':s})

@login_required(login_url='/myapp/login_get/')
def editsubject_get(request,id):
    i = Subjects.objects.get(id=id)
    return render(request, 'admin/edit_subject.html',{'i':i})

def editsubject_post(request):
    id = request.POST['id']
    i = Subjects.objects.get(id=id)
    name = request.POST['name']
    sem = request.POST['sem']

    i.subname=name
    i.semester=sem
    i.save()
    print('ssss',i)
    messages.success(request, 'Subject details edited')
    return redirect('/myapp/view_subjects_get/')

def delete_subject(request,id):
    i = Subjects.objects.get(id=id)
    i.delete()
    messages.success(request, 'Subject deleted')
    return redirect('/myapp/view_subjects_get/')

@login_required(login_url='/myapp/login_get/')
def assign_subjects_get(request):
    all_subjects = Subjects.objects.all()
    all_staff = Staff.objects.all()
    return render(request, 'admin/assign_subjects.html', {'subjects': all_subjects, 'staffs': all_staff})


def assignsubjects_post(request):
    subject=request.POST['subject']
    staff=request.POST['staff']

    a=Assign_subj()
    a.STAFF_id=staff
    a.SUBJECT_id=subject
    a.save()

    messages.success(request, 'Subject Assigned')
    return redirect('/myapp/view_assignedsubjects/')


@login_required(login_url='/myapp/login_get/')
def view_assignedsubjects(request):
    res=Assign_subj.objects.all()
    return render(request,"admin/view_assigned_subjects.html",{"data":res})

@login_required(login_url='/myapp/login_get/')
def editassigned_get(request,id):
    i = Assign_subj.objects.get(id=id)
    all_subjects = Subjects.objects.all()
    all_staff = Staff.objects.all()
    return render(request, 'admin/edit_assig_subj.html',{'i':i,'subjects': all_subjects, 'staffs': all_staff})

def editassigned_post(request):
    id = request.POST['id']
    i = Assign_subj.objects.get(id=id)
    subject = request.POST['subject']
    staff = request.POST['staff']


    i.SUBJECT_id = subject
    i.STAFF_id = staff
    i.save()

    messages.success(request, 'Assigned Details edited')
    return redirect('/myapp/view_assignedsubjects/')

def delete_assigned(request,id):
    i = Assign_subj.objects.get(id=id)
    i.delete()
    messages.success(request, 'Details deleted')
    return redirect('/myapp/view_assignedsubjects/')

@login_required(login_url='/myapp/login_get/')
def view_feedback_admin(request):
    res=Feedback.objects.all()
    return render(request,"admin/view_feedback.html",{"data":res})


@login_required(login_url='/myapp/login_get/')
def send_notification_admin(request):
    return render(request, 'admin/add_notification.html')


def add_notification_post(request):
    name=request.POST['notif']

    s=Notification()
    s.notification=name
    s.date=date.today()
    s.save()
    messages.success(request, 'Notification Send')
    return redirect('/myapp/admin_home/')

@login_required(login_url='/myapp/login_get/')
def view_notification_admin(request):
    n=Notification.objects.all()
    return render(request,'admin/view_nofication.html',{'data':n})

def delete_notofication(request,id):
    i = Notification.objects.get(id=id)
    i.delete()

    messages.success(request, 'Details deleted')
    return redirect('/myapp/view_notification_admin/')

@login_required(login_url='/myapp/login_get/')
def changepwd_admin_get(request):
    return render(request,'admin/change_password.html')

def changepwd_admin_post(request):
    if request.method== 'POST':
        cpass=request.POST['cpass']
        npass = request.POST['npass']
        cmpass=request.POST['cmpass']

        user=request.user

        if not user.check_password(cpass):
            messages.error(request, 'Current password incorrect')
            return redirect('/myapp/changepwd_admin_get/')
        if npass != cmpass:
            messages.error(request, 'New password and confirm password do not match')
            return redirect('/myapp/changepwd_admin_get/')

        user.set_password(npass)
        user.save()
        messages.error(request, ' password changed')
        return redirect('/myapp/login_get/')

@login_required(login_url='/myapp/login_get/')
def admin_view_complaints(request):
    var = Complaints.objects.all()
    return render(request, 'admin/view_complaints.html', {'data': var})


@login_required(login_url='/myapp/login_get/')
def admin_compl_reply_get(request,id):
    i = Complaints.objects.get(id=id)
    return render(request,'admin/send_compl_reply.html',{'data':i})


def admin_compl_reply_post(request):
    id=request.POST['id']
    r=request.POST['reply']
    var=Complaints.objects.get(id=id)
    var.reply=r
    var.save()
    messages.success(request, 'replied')
    return redirect('/myapp/admin_view_complaints/')


# =====================================================
# =====================STAFF===========================
# =====================================================



def staff_register_get(request):
    return render(request,'staff_register.html')

def staff_register_post(request):
    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        phone = request.POST['phone']
        place = request.POST['place']
        dob = request.POST['dob']
        qualification = request.POST['qualification']
        photo = request.FILES['photo']
        pwd = request.POST['pwd']
        cpwd = request.POST['cpwd']

        if pwd != cpwd:
            messages.error(request, "Passwords do not match.")
            return redirect('/myapp/staff_register_get/')

        var=User.objects.filter(Q(username=email)|Q(email=email))
        if var.exists():
            messages.error(request,'User Already Exists')
            return redirect('/myapp/staff_register_get/')

        fs = FileSystemStorage()
        path = fs.save(photo.name, photo)


        ab = User.objects.create(
            username=email,
            password=make_password(pwd),
            email=email,
            first_name=name
        )

        ab.groups.add(Group.objects.get(name='staff'))

        var = Staff()
        var.LOGIN = ab
        var.name = name
        var.email = email
        var.place = place
        var.dob = dob
        var.phone = phone
        var.qualification = qualification
        var.photo = path
        var.status = 'Blocked'
        var.save()
        messages.success(request, 'Registered')
        return redirect('/myapp/login_get/')



def staff_home(request):
    return render(request,'staff/home.html')


@login_required(login_url='/myapp/login_get/')
def staff_viewprofile(request):
    res=Staff.objects.get(LOGIN=request.user)
    return render(request,"staff/view_profile.html",{"i":res})

@login_required(login_url='/myapp/login_get/')
def staff_edit_profile_get(request,id):
    p=Staff.objects.get(id=id)
    return render(request,'staff/edit_profile.html',{"i":p})

def staff_edit_profile_post(request):
    id = request.POST['id']
    name = request.POST['name']
    email = request.POST['email']
    phone = request.POST['phone']
    place = request.POST['place']
    dob = request.POST['dob']
    qualification = request.POST['qualification']

    data = Staff.objects.get(id=id)
    user = data.LOGIN
    user.username = email
    user.email = email
    user.save()

    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs = FileSystemStorage()
        path = fs.save(photo.name, photo)
        data.photo = path
    data.name = name
    data.phone = phone
    data.place = place
    data.email = email
    data.dob = dob
    data.qualification = qualification
    data.save()
    messages.success(request, 'Profile edited')
    return redirect('/myapp/staff_viewprofile/')

@login_required(login_url='/myapp/login_get/')
def staff_view_students_get(request):
    s = Student.objects.all()
    return render(request, 'staff/view_students.html',{'data':s})

@login_required(login_url='/myapp/login_get/')
def staffview_subjects_get(request):
    res=Assign_subj.objects.filter(STAFF__LOGIN__id=request.user.id)

    return render(request,"staff/view_assigned_subj.html",{"assi":res,})


@login_required(login_url='/myapp/login_get/')
def add_matierial_get(request):
    all_subjects = Assign_subj.objects.filter(STAFF__LOGIN=request.user)
    return render(request,'staff/add_notes.html',{'subjects': all_subjects,})

def add_matierial_post(request):
    subject_id=request.POST['subject']
    date=request.POST['date']
    materials=request.FILES['materials']
    title=request.POST['title']

    tm=Notes()
    tm.SUBJECT = Subjects.objects.get(id=subject_id)
    tm.STAFF=Staff.objects.get(LOGIN__id=request.user.id)
    tm.date=date
    tm.title=title
    tm.materials=materials
    tm.save()

    messages.success(request, 'Study material Added')
    return redirect('/myapp/staff_home/')


@login_required(login_url='/myapp/login_get/')
def view_studymaterial(request):
    res=Notes.objects.filter(STAFF__LOGIN__id=request.user.id)
    return render(request,"staff/view_notes.html",{"data":res})


@login_required(login_url='/myapp/login_get/')
def edit_material_get(request,id):
    i = Notes.objects.get(id=id)
    all_subjects = Assign_subj.objects.filter(STAFF__LOGIN__id=request.user.id)
    return render(request, 'staff/edit_notes.html',{'i':i,'subjects': all_subjects,})

def edit_material_post(request):
    id = request.POST['id']
    subject = request.POST['subject']
    date=request.POST['date']
    i = Notes.objects.get(id=id)
    if 'materials' in request.FILES:
        materials=request.FILES['materials']
        fs=FileSystemStorage()
        path=fs.save(materials.name,materials)
        i.materials = path

    i.SUBJECT_id = subject
    i.STAFF=Staff.objects.get(LOGIN__id=request.user.id)
    i.date=date

    i.save()
    print('ssss',i)
    messages.success(request, 'Study Material edited')
    return redirect('/myapp/view_studymaterial/')

def delete_studymaterial(request,id):
    i = Notes.objects.get(id=id)
    i.delete()

    messages.success(request, 'Details deleted')
    return redirect('/myapp/view_studymaterial/')




@login_required(login_url='/myapp/login_get/')
def staff_change_pwd_get(request):
    return render(request,'staff/change_passwrd.html')

@login_required(login_url='/myapp/login_get/')
def staffview_notific(request):
    n=Notification.objects.all()
    return render(request,'staff/view_notifications.html',{'data':n})

def changepwd_staff_post(request):
    if request.method== 'POST':
        cpass=request.POST['cpass']
        npass = request.POST['npass']
        cmpass=request.POST['cmpass']

        user=request.user

        if not user.check_password(cpass):
            messages.error(request, 'Current password incorrect')
            return redirect('/myapp/staff_change_pwd_get/')
        if npass != cmpass:
            messages.error(request, 'New password and confirm password do not match')
            return redirect('/myapp/staff_change_pwd_get/')

        user.set_password(npass)
        user.save()
        messages.error(request, ' password changed')
        return redirect('/myapp/login_get/')

@login_required(login_url='/myapp/login_get/')
def staffview_doubt_get(request):
    res = Doubts.objects.filter(STAFF__LOGIN__id=request.user.id)

    return render(request, "staff/view_doubt.html", {"data": res, })


@login_required(login_url='/myapp/login_get/')
def staff_doubt_reply_get(request,id):
    i = Doubts.objects.get(id=id)
    return render(request,'staff/reply_doubt.html',{'i':i})

def staff_doubt_reply_post(request):
    id=request.POST['id']
    r=request.POST['reply']
    var=Doubts.objects.get(id=id)
    var.reply=r
    var.save()
    messages.success(request, 'replied')
    return redirect('/myapp/staffview_doubt_get/')


@login_required(login_url='/myapp/login_get/')
def staffadd_exam_get(request):
    s=Subjects.objects.all()
    return render(request,'staff/add_exam.html',{'subjects':s})

def add_test_post(request):
    subject_id = request.POST['subject']
    details = request.POST['details']
    test_date = request.POST['date']

    t = Test()
    t.SUBJECT = Subjects.objects.get(id=subject_id)
    t.STAFF = Staff.objects.get(LOGIN__id=request.user.id)
    t.details = details
    t.date = test_date
    t.save()

    messages.success(request, "Test added successfully!")
    return redirect('/myapp/staff_view_exam_get/')


@login_required(login_url='/myapp/login_get/')
def staff_view_exam_get(request):
    e = Test.objects.filter(STAFF__LOGIN__id=request.user.id)
    return render(request,'staff/view_exams.html',{'tests':e})

@login_required(login_url='/myapp/login_get/')
def staffadd_qstn_get(request,id):
    q=Test.objects.get(id=id)
    return render(request,'staff/add_questions.html',{'i':q})

def add_question_post(request):
    test_id = request.POST['test']
    question = request.POST['question']
    option1 = request.POST['option1']
    option2 = request.POST['option2']
    option3 = request.POST['option3']
    option4 = request.POST['option4']
    answer = request.POST['answer']
    score = request.POST['score']

    q = Question_Answers()
    q.TEST = Test.objects.get(id=test_id)
    q.question = question
    q.option1 = option1
    q.option2 = option2
    q.option3 = option3
    q.option4 = option4
    q.answer = answer
    q.score = score
    q.date = date.today()
    q.save()

    messages.success(request, "Question added successfully!")
    return redirect('/myapp/staff_home/')

@login_required(login_url='/myapp/login_get/')
def view_questions(request,id):
    data = Question_Answers.objects.filter(TEST_id=id)
    return render(request, "staff/view_questions.html", {"data": data})


def delete_question(request,id):
    i = Question_Answers.objects.get(id=id)
    i.delete()

    messages.success(request, 'Details deleted')
    return redirect('/myapp/staff_view_exam_get/')

def delete_exam(request,id):
    i = Test.objects.get(id=id)
    i.delete()

    messages.success(request, 'Details deleted')
    return redirect('/myapp/staff_view_exam_get/')

@login_required(login_url='/myapp/login_get/')
def staffview_result(request):
    res=TestResult.objects.all()
    return render(request,"staff/view_results.html",{"data":res})




# =============================================================
# ========================STUDENT==============================
# =============================================================


def student_login(request):
    if request.method == "POST":
        uname = request.POST.get('Username')
        pwd = request.POST.get('Password')

        user = authenticate(request, username=uname, password=pwd)

        if user is not None:
            login(request, user)
            lid = user.id
            if user.groups.filter(name="student").exists():
                s= Student.objects.get(LOGIN_id=lid)
                print(lid,'lid')
                print(s.id,'sid')
                return JsonResponse({
                    'status': 'ok',
                    'type': 'student',
                    'lid': str(lid),
                    'sid': str(s.id),
                    'message': 'Login successful'
                })
            else:
                return JsonResponse({
                    'status': 'failed',
                    'message': 'Student record not found'
                })

        else:
            return JsonResponse({
                'status': 'failed',
                'message': 'Invalid username or password'
            })
    else:
        return JsonResponse({
            'status': 'failed',
            'message': 'Only POST requests are allowed'
        })



def std_viewprofile(request):
    lid = request.POST['lid']
    print(lid,'login_id================')
    profile = Student.objects.get(LOGIN_id=lid)
    print(profile,'-----------------')
    return JsonResponse({'status': 'ok',
                         'name': str(profile.name),
                         'email': str(profile.email),
                         'place': str(profile.place),
                         'dob': str(profile.dob),
                         'semester': str(profile.semester),
                         'photo': str(profile.photo),
                         'phone':str(profile.phone),})

def student_viewstaff(request):
    n = Staff.objects.all()
    print(n,'ssss')
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'name': i.name,
            'place': i.place,
            'qualification': i.qualification,
            'phone': i.phone,

        })

    print(data)

    return JsonResponse({'status': 'ok','data': data})


def ask_doubt(request):
    sid = request.POST['sid']
    print(sid,'studdt')
    doubt = request.POST['doubt']
    staff_id = request.POST['staff_id']
    print(staff_id,'staff')

    tm = Doubts()
    tm.STAFF_id = staff_id
    tm.STUDENT_id = sid
    tm.doubt = doubt
    tm.date = date.today()
    tm.reply = 'pending'
    tm.save()

    return JsonResponse({'status': 'ok'})

def student_view_reply(request):
    sid = request.POST['sid']
    print(sid,'id')
    n = Doubts.objects.filter(STUDENT_id=sid)
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'reply':i.reply,
            'date':i.date,
            'doubt': i.doubt,
            'staff': i.STAFF.name,
        })
    print(data)
    return JsonResponse({'status': 'ok','data': data})

def send_complaint(request):
    compl = request.POST['name']

    sid = request.POST.get('sid')
    #
    print('fdg------------------------------hj',sid)

    tm = Complaints()
    tm.complaint = compl
    tm.STUDENT_id = sid
    tm.reply = 'pending'
    tm.date=date.today()
    tm.save()


    return JsonResponse({'status': 'ok',
    'message': 'successfully submitted.'})

def std_viewcomplaint(request):
    sid = request.POST['sid']
    print(sid,'id----------------')

    n = Complaints.objects.filter(STUDENT_id=sid)
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'complaint': i.complaint,
            'replay': i.reply,
            'date':i.date
        })
    print(data)
    return JsonResponse({'status': 'ok','data': data})

def send_feedback(request):
    sid = request.POST['sid']
    print(sid,'sss')
    feedback = request.POST['feedback']


    tm = Feedback()

    tm.feedback = feedback
    tm.STUDENT_id = sid
    tm.date = date.today()
    tm.save()

    return JsonResponse({'status': 'ok'})

def student_viewsubject(request):
    n = Subjects.objects.all()
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'subject': i.subname,
            'semester': i.semester,
        })
    print(data)
    return JsonResponse({'status': 'ok','data': data})



def student_viewexam(request):
    n = Test.objects.all()
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'subject': i.SUBJECT.subname,
            'details': i.details,
            'staff': i.STAFF.name,
            'date': i.date,
        })
    print(data)
    return JsonResponse({'status': 'ok','data': data})








def student_viewstudymaterial(request):
    subject_id = request.POST['subject_id']
    print(subject_id,'id')
    n = Notes.objects.filter(SUBJECT_id=subject_id)
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'date':i.date,
            'materials': request.build_absolute_uri(i.materials.url),
            'staff': i.STAFF.name,

        })

    print(data)

    return JsonResponse({'status': 'ok','data': data})

def student_viewnotif(request):
    n = Notification.objects.all()
    data = []

    for i in n:
        data.append({
            'id':i.id,
            'date': i.date,

            'title': i.notification,
        })

    print(data)

    return JsonResponse({'status': 'ok','data': data})


def std_changepassword(request):

    oldpassword = request.POST['oldpassword']
    newpassword = request.POST['newpassword']
    confirmpassword = request.POST['confirmpassword']
    lid = request.POST['lid']
    print(request.POST,'=============')

    user = User.objects.get(id=lid)
    if user.check_password(oldpassword):
        if newpassword == confirmpassword:
            user.set_password(newpassword)
            user.save()
            return JsonResponse({'status': 'ok', 'message': 'Password changed successfully'})
        else:
            return JsonResponse({'status': 'error', 'message': 'Passwords do not match'})
    else:
        return JsonResponse({'status': 'error', 'message': 'Old password incorrect'})




def student_view_questions(request):
    # Get the test/exam ID from POST
    test_id = request.POST.get('test_id')
    print("Test ID:", test_id)

    # Filter questions for that test
    questions = Question_Answers.objects.filter(TEST_id=test_id)

    # Prepare data list
    data = []
    for q in questions:
        data.append({
            'id': q.id,
            'question': q.question,
            'option1': q.option1,
            'option2': q.option2,
            'option3': q.option3,
            'option4': q.option4,
            'score': q.score,
        })

    print(data)
    return JsonResponse({'status': 'ok', 'data': data})





# def submit_answer(request):
#     if request.method == 'POST':
#         try:
#             student_id = request.POST.get('student_id')
#             answers_json = request.POST.get('answer', '{}')
#             answers = json.loads(answers_json)
#
#             student = Student.objects.get(id=student_id)
#
#             # --- Get first question_id from answers ---
#             first_qid = int(list(answers.keys())[0])
#             first_question = Question_Answers.objects.get(id=first_qid)
#             test_id = first_question.TEST.id
#
#             # --- CHECK IF ALREADY SUBMITTED THIS TEST ---
#             already = Attend.objects.filter(
#                 STUDENT_id=student_id,
#                 QUESTION__TEST_id=test_id
#             ).exists()
#
#             if already:
#                 return JsonResponse({
#                     'status': 'error',
#                     'message': 'Already submitted this exam'
#                 })
#
#             # --- SAVE ANSWERS ---
#             for qid_str, selected_option in answers.items():
#                 qid = int(qid_str)
#                 question = Question_Answers.objects.get(id=qid)
#
#                 mark = question.score if selected_option == question.answer else 0
#
#                 Attend.objects.create(
#                     STUDENT=student,
#                     QUESTION=question,
#                     answer=selected_option,
#                     mark=str(mark),
#                     date=str(date.today())
#                 )
#
#             return JsonResponse({'status': 'ok', 'message': 'Answers submitted successfully'})
#
#         except Exception as e:
#             return JsonResponse({'status': 'error', 'message': str(e)})
#
#     return JsonResponse({'status': 'error', 'message': 'Invalid request method'})



def submit_answer(request):
    if request.method == 'POST':
        try:
            student_id = request.POST.get('student_id')
            answers_json = request.POST.get('answer', '{}')
            answers = json.loads(answers_json)

            student = Student.objects.get(id=student_id)

            # Get TEST from first question
            first_qid = int(list(answers.keys())[0])
            first_question = Question_Answers.objects.get(id=first_qid)
            test = first_question.TEST

            # ✅ CHECK: already written this test before?
            if TestResult.objects.filter(STUDENT=student, TEST=test).exists():
                return JsonResponse({
                    'status': 'error',
                    'message': 'Already submitted this exam'
                })

            total_mark = 0   # will accumulate total marks

            # --- SAVE ANSWERS ONE BY ONE ---
            for qid_str, selected_option in answers.items():

                qid = int(qid_str)
                question = Question_Answers.objects.get(id=qid)

                # calculate mark for this question
                mark = int(question.score) if selected_option == question.answer else 0
                total_mark += mark

                # Save to Attend table
                Attend.objects.create(
                    STUDENT=student,
                    QUESTION=question,
                    answer=selected_option,
                    mark=str(mark),
                    date=str(date.today())
                )

            # --- FINALLY SAVE TOTAL MARK ---
            TestResult.objects.create(
                STUDENT=student,
                TEST=test,
                total_mark=total_mark,
                date=str(date.today())
            )

            return JsonResponse({
                'status': 'ok',
                'message': 'Answers submitted successfully',
                'total_mark': total_mark
            })

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})



#
# def student_view_results(request):
#     student_id = request.session.get('student_id') or request.POST.get('sid')
#
#     if not student_id:
#         return JsonResponse({'status': 'error', 'message': 'Student ID not provided'})
#
#     tests = Test.objects.all()
#     data = []
#
#     for test in tests:
#         # Get all attend entries for this student and test
#         attended_marks = Attend.objects.filter(
#             STUDENT_id=student_id,
#             QUESTION__TEST=test
#         )
#
#         # Calculate total scored and total possible
#         total_score = sum(int(a.mark) for a in attended_marks) if attended_marks.exists() else 0
#         total_possible = sum(int(a.QUESTION.score) for a in attended_marks) if attended_marks.exists() else 0
#
#         data.append({
#             'id': test.id,
#             'subject': test.SUBJECT.subname,
#             'score': str(total_score),
#             'total': str(total_possible),
#             'date': test.date,
#         })
#
#     return JsonResponse({'status': 'ok', 'data': data})


from django.http import JsonResponse
from .models import TestResult

def student_view_results(request):
    student_id = request.session.get('student_id') or request.POST.get('sid')

    if not student_id:
        return JsonResponse({'status': 'error', 'message': 'Student ID not provided'})

    results = TestResult.objects.filter(STUDENT_id=student_id)
    data = []

    for result in results:
        data.append({
            'id': result.TEST.id,
            'subject': result.TEST.SUBJECT.subname,
            'score': str(result.total_mark),                  # use total_mark from TestResult
            'total': str(sum(int(q.score) for q in result.TEST.question_answers_set.all())),  # total possible
            'date': result.date,
        })

    return JsonResponse({'status': 'ok', 'data': data})


from django.http import JsonResponse
from .models import Student, Attend, Notes
from difflib import SequenceMatcher

def similar(a, b):
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()  # returns 0..1

def recommended_notes(request):
    if request.method == 'POST':
        student_id = request.POST.get('student_id')
        print("Received student_id:", student_id)

        try:
            student = Student.objects.get(id=student_id)
            print("Student found:", student)
        except Student.DoesNotExist:
            print("Student not found")
            return JsonResponse({'status': 'error', 'message': 'Student not found'})

        failed_questions = Attend.objects.filter(STUDENT=student, mark='0')
        print("Failed questions:", failed_questions.count())

        if not failed_questions.exists():
            print("No failed questions")
            return JsonResponse({'status': 'ok', 'data': [], 'message': 'No failed questions.'})

        all_notes = Notes.objects.all()
        print("Total notes in database:", all_notes.count())

        recommended = []
        threshold = 0.3  # minimum similarity to consider a match (adjustable)

        for attend in failed_questions:
            question_text = attend.QUESTION.question
            print("Checking failed question:", question_text)

            for note in all_notes:
                title = note.title
                file_name = note.materials.name

                title_similarity = similar(question_text, title)
                file_similarity = similar(question_text, file_name)

                print(f"Comparing with note: {title} -> title_similarity: {title_similarity:.2f}, file_similarity: {file_similarity:.2f}")

                if title_similarity >= threshold or file_similarity >= threshold:
                    if note.id not in [n['id'] for n in recommended]:
                        recommended.append({
                            'id': note.id,
                            'title': note.title,
                            'file': request.build_absolute_uri(note.materials.url),
                            'date': note.date,
                        })
                        print(f"Matched note: {note.title} for question: {question_text}")

        print("Total recommended notes:", len(recommended))
        return JsonResponse({'status': 'ok', 'data': recommended})

    print("Invalid request method")
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})



# ==============================================================





import re
from difflib import SequenceMatcher

def similar(a, b):
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()

def extract_keywords(text):
    text = text.lower()
    text = re.sub(r'[^a-zA-Z0-9\s]', ' ', text)
    words = text.split()

    stopwords = ["what", "is", "the", "for", "of", "explain", "define",
                 "send", "notes", "material", "give", "me", "a", "an"]

    keywords = [w for w in words if w not in stopwords and len(w) > 2]

    return keywords

#
# def chatbot_recommend_notes(request):
#     if request.method != 'POST':
#         return JsonResponse({'status': 'error', 'message': 'POST required'})
#
#     user_message = request.POST.get('message')
#     if not user_message:
#         return JsonResponse({'status': 'error', 'message': 'No message received'})
#
#     # Extract keywords locally
#     topics_list = extract_keywords(user_message)
#     print("Extracted keywords:", topics_list)
#
#     all_notes = Notes.objects.all()
#     recommended = []
#     threshold = 0.30
#
#     for note in all_notes:
#         title = note.title
#         file_name = note.materials.name
#
#         for topic in topics_list:
#             score_title = similar(topic, title)
#             score_file = similar(topic, file_name)
#
#             print(f"Match '{topic}' -> '{title}' : {score_title:.2f}")
#
#             if score_title >= threshold or score_file >= threshold:
#                 if note.id not in [n['id'] for n in recommended]:
#                     recommended.append({
#                         'id': note.id,
#                         'title': note.title,
#                         'file': request.build_absolute_uri(note.materials.url),
#                         'date': note.date,
#                     })
#
#     return JsonResponse({'status': 'ok', 'data': recommended})




def chatbot_recommend_notes(request):
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'POST required'})

    user_message = request.POST.get('message')
    if not user_message:
        return JsonResponse({'status': 'error', 'message': 'No message received'})

    topics_list = extract_keywords(user_message)
    print("Extracted keywords:", topics_list)

    all_notes = Notes.objects.all()
    recommended = []
    threshold = 0.50

    for note in all_notes:
        title = note.title
        file_name = note.materials.name

        for topic in topics_list:
            score_title = similar(topic, title)
            score_file = similar(topic, file_name)

            print(f"Match '{topic}' -> '{title}' : {score_title:.2f}")

            if score_title >= threshold or score_file >= threshold:
                if note.id not in [n['id'] for n in recommended]:
                    recommended.append({
                        'id': note.id,
                        'title': note.title,
                        'file': request.build_absolute_uri(note.materials.url),
                        'date': str(note.date),
                    })

    # ---------------------------------------------
    # NO MATCH FOUND → reply message
    # ---------------------------------------------
    if not recommended:
        return JsonResponse({
            'status': 'nomatch',
            'message': "❌ Sorry, I couldn't find any notes related to your question."
        })

    return JsonResponse({'status': 'ok', 'data': recommended})
