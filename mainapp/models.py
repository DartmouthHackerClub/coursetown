from django.db import models

class Course(models.Model):
    dept = models.CharField(max_length=4)
    num = models.IntegerField()

    def __unicode__(self):
        return "%s%i" % dept, num

class Offering(models.Model):
    course = models.ForeignKey(Course)
    year = models.IntegerField()
    season = models.CharField(max_length=1) # F,W,S,X
    prof = models.CharField(max_length=9000)
    time = models.CharField(max_length=4) #10, 10A, etc
    #TODO: prerequisites

    def __unicode__(self):
        return "%s%i%s" % course.__unicode__(), year, season


