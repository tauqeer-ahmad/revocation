jQuery ->
  $( ".select2_dropdown" ).select2
    theme: "bootstrap"
    width: '100%'

  if $('#exam_timetable_subject_id').length
    subjects = $('#exam_timetable_subject_id').html()
    update_subjects(subjects)
  $('#exam_timetable_klass_id').change ->
    update_subjects(subjects)

update_subjects = (subjects) ->
  klass = $('#exam_timetable_klass_id :selected').text()
  return $('#exam_timetable_subject_id').empty() if klass == "Select Class"
  options = $(subjects).filter("optgroup[label=#{klass}]").html()

  if options
    $('#exam_timetable_subject_id').html(options)
  else
    $('#exam_timetable_subject_id').empty()
