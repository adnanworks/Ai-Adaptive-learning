from django.contrib.auth.models import User
from django.db import models

# Create your models here.



class Staff(models.Model):
    LOGIN=models.OneToOneField(User,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    place=models.CharField(max_length=100)
    dob=models.CharField(max_length=100)
    phone = models.CharField(max_length=100)
    qualification=models.CharField(max_length=100)
    photo=models.FileField()
    status=models.CharField(max_length=100)


class Student(models.Model):
    LOGIN=models.OneToOneField(User,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    dob = models.CharField(max_length=100)
    phone = models.CharField(max_length=100)
    semester = models.CharField(max_length=100)
    photo = models.FileField()

class Subjects(models.Model):
    subname=models.CharField(max_length=100)
    semester=models.CharField(max_length=100)

class Assign_subj(models.Model):
    STAFF = models.ForeignKey(Staff, on_delete=models.CASCADE)
    SUBJECT = models.ForeignKey(Subjects, on_delete=models.CASCADE)

class Feedback(models.Model):
    feedback = models.CharField(max_length=100)
    STUDENT = models.ForeignKey(Student, on_delete=models.CASCADE)
    date = models.CharField(max_length=100)

class Complaints(models.Model):
    STUDENT = models.ForeignKey(Student, on_delete=models.CASCADE)
    complaint = models.CharField(max_length=100)
    reply = models.CharField(max_length=100)
    date = models.CharField(max_length=100)

class Notification(models.Model):
    notification = models.CharField(max_length=100)
    date = models.CharField(max_length=100)

class Doubts(models.Model):
    STUDENT = models.ForeignKey(Student, on_delete=models.CASCADE)
    STAFF = models.ForeignKey(Staff, on_delete=models.CASCADE)
    doubt = models.CharField(max_length=100)
    reply = models.CharField(max_length=100)
    date = models.CharField(max_length=100)

class Notes(models.Model):
    date = models.CharField(max_length=100)
    title = models.CharField(max_length=100)
    SUBJECT = models.ForeignKey(Subjects, on_delete=models.CASCADE)
    STAFF = models.ForeignKey(Staff, on_delete=models.CASCADE)
    materials = models.FileField()

class Test(models.Model):
    STAFF = models.ForeignKey(Staff, on_delete=models.CASCADE)
    SUBJECT = models.ForeignKey(Subjects, on_delete=models.CASCADE)
    details = models.CharField(max_length=400)
    date = models.CharField(max_length=100)
    # age = models.CharField(max_length=100)


class Question_Answers(models.Model):
    TEST = models.ForeignKey(Test, on_delete=models.CASCADE)
    option1 = models.CharField(max_length=400)
    option2 = models.CharField(max_length=400)
    option3 = models.CharField(max_length=400)
    option4 = models.CharField(max_length=400)
    question = models.CharField(max_length=400)
    answer = models.CharField(max_length=400)
    score = models.CharField(max_length=400)
    date = models.CharField(max_length=100)

class Attend(models.Model):
    STUDENT = models.ForeignKey(Student, on_delete=models.CASCADE)
    QUESTION = models.ForeignKey(Question_Answers, on_delete=models.CASCADE)
    date = models.CharField(max_length=100)
    answer = models.CharField(max_length=300)
    mark = models.CharField(max_length=300)

class TestResult(models.Model):
    STUDENT = models.ForeignKey(Student, on_delete=models.CASCADE)
    TEST = models.ForeignKey(Test, on_delete=models.CASCADE)
    total_mark = models.IntegerField()
    date = models.CharField(max_length=100)
