from django.test import TestCase
from coursetown.mainapp.models import Course, Offering
from coursetown.mainapp import util

def get_and_insert_offering(dept='RUSS', num=13, year=11, season='F', prof='Devin Balkcom'):
    c_kwargs = {
        'dept': dept,
        'num': num,
        }
    c = Course(**c_kwargs)
    c.save()
    o_kwargs = {
        'course': c,
        'year': year,
        'season': season,
        'prof': prof,
        }
    o = Offering(**o_kwargs)
    o.save()
    return o
    

class BasicTest(TestCase):
    def test_create_course(self):
        c_kwargs = {
            'dept': 'COSC',
            'num': 1,
            }
        c = Course(**c_kwargs)
        c.save()
        self.assertEqual(c.dept, c_kwargs['dept'])

class SpaceRemainingTest(TestCase):
    def test_space_remaining(self):
        o = get_and_insert_offering()
        space_remaining = util.get_space_remaining(o)
        self.assertEqual(type(space_remaining), int)

class GetBooksTest(TestCase):
    def test_get_books(self):
        o = get_and_insert_offering()
        books = util.get_books(o)
        self.assertEqual(type(books), str)
        self.assertTrue(len(books) > 5)

class CalendarTest(TestCase):
    def test_get_ical(self):
        o = get_and_insert_offering()
        ical = util.get_ical(o)
        self.assertEqual(ical[0:7], 'BEGIN:')

class GetReviewsTest(TestCase):
    def test_get_reviews(self):
        o = get_and_insert_offering()
        reviews = util.get_reviews(o)
        self.assertEqual(type(reviews), list)
