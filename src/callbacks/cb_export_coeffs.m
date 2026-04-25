%% DESCRIPTION
%  Callback: exports b, a coefficients to workspace or file.
%% INPUTS
%  hobj  handle — source widget
%  evt   struct — event data
%% OUTPUTS
%  none

function cb_export_coeffs(hobj, evt)
  handles = guidata(hobj);
  b = handles.b;
  a = handles.a;

  choice = menu('Export Coefficients', ...
    'Export to workspace (b, a)', ...
    'Save as .mat file', ...
    'Save as .txt file', ...
    'Cancel');

  switch choice
    case 1
      assignin('base', 'b', b);
      assignin('base', 'a', a);
      msgbox('Variables b and a exported to workspace.', 'Export', 'help');

    case 2
      [fname, fpath] = uiputfile('*.mat', 'Save coefficients as .mat');
      if fname ~= 0
        save(fullfile(fpath, fname), 'b', 'a');
      end

    case 3
      [fname, fpath] = uiputfile('*.txt', 'Save coefficients as .txt');
      if fname ~= 0
        fid = fopen(fullfile(fpath, fname), 'w');
        fprintf(fid, '# b (numerator)\n');
        fprintf(fid, '%.10g\n', b);
        fprintf(fid, '# a (denominator)\n');
        fprintf(fid, '%.10g\n', a);
        fclose(fid);
      end
  end
end
