ThinkingSphinx::Index.define :offering, :with => :active_record do
  indexes courses.short_title, :as => :short_title
  indexes courses.long_title, :as => :long_title
  indexes courses.department, :as => :department
  indexes courses.number, :as => :number
  indexes professors.name, :as => :professor

  has median_grade, created_at, updated_at
end
