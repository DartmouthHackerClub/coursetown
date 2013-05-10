ThinkingSphinx::Index.define :offering, :with => :active_record do
  indexes courses.short_title
  indexes courses.long_title
  indexes courses.desc
  indexes courses.department
  indexes courses.number
  indexes professors.name

  has median_grade, created_at, updated_at
end
