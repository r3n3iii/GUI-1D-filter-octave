%% DESCRIPTION
%  Callback: FIR/IIR radio button changed. Swaps method list and updates visibility.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_filter_type(hobj, evt)
  handles = guidata(hobj);

  if strcmp(get(hobj, 'Tag'), 'rb_fir')
    handles.filter_type   = 'FIR';
    handles.design_method = 'window';
    set(handles.rb_fir, 'Value', 1);
    set(handles.rb_iir, 'Value', 0);
    set(handles.dd_method, ...
      'String', {'Window', 'Least-Squares', 'Parks-McClellan'}, ...
      'Value', 1);
  else
    handles.filter_type   = 'IIR';
    handles.design_method = 'butter';
    set(handles.rb_fir, 'Value', 0);
    set(handles.rb_iir, 'Value', 1);
    set(handles.dd_method, ...
      'String', {'Butterworth', 'Chebyshev I', 'Chebyshev II', 'Elliptic'}, ...
      'Value', 1);
  end

  guidata(hobj, handles);
  apply_param_visibility(handles);
end
