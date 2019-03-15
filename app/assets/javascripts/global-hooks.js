function bindGUIElements() {
  $(".datepicker:not(.hasDatepicker)").datetimepicker({
    controlType: 'select',
    timeFormat: 'hh:mm tt'
  });
}
