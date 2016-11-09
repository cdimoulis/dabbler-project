module PersonLists
  extend ActiveSupport::Concern

  PREFIXES = ['Not Specified', 'Miss', 'Master', 'Prof.', 'Rabbi', 'Pastor', 'Father', 'Rev.', 'Dr.', 'Ms.', 'Mrs.', 'Mr.']
  SUFFIXES = [
    'Not Specified',
    'Sr.', 'Jr.', 'II', 'III', 'IV', 'V', # Generational
    'Esq.',
    'B.A.', 'B.S.', # Bachelor
    'M.A.', 'M.S.', # Masters
    'J.D.', 'M.D.', 'D.O.', 'D.C.', 'Ph.D.' # Doctorate
  ]
  GENDERS = [ 'Not Specified', 'Male', 'Female', 'Other' ]
  
end
