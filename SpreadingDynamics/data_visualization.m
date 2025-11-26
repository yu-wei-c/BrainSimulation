clear variables %#ok<*NASGU>
addpath([fileparts(fileparts(which('braph2'))) filesep 'SpreadingDynamics'])

%% Visulaize Brain Atlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(fileparts(which('braph2'))) filesep 'SpreadingDynamics' filesep 'data' filesep 'aal_selected_atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');
bapf = BrainAtlasPF('BA', ba);
gui_bapf = GUIFig('PF', bapf);
gui_bapf.get('DRAW');
gui_bapf.get('SHOW')

bapf.get('ST_SURFACE').set('FACEALPHA', 0.6);
bapf.get('ST_AMBIENT').set('CAMLIGHT', 'headlight');
bapf.get('ST_AMBIENT').set('SHADING', 'interp');
bapf.get('ST_AMBIENT').set('COLORMAP', 'white');
bapf.get('ST_AMBIENT').set('COLORMAP', 'none');
bapf.set('SPHS', false);
bapf.set('SPHS', true);
contenttype = 'vector'; resolution = 300; colorspace = 'rgb';
bapf.set('VIEW', BrainSurfacePF.VIEW_SL_AZEL)
braph2print(gui_bapf.get('PF').get('H'), [fileparts(fileparts(which('braph2'))) filesep 'SpreadingDynamics' filesep 'atlas_SL.jpg'], 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)
bapf.set('VIEW', BrainSurfacePF.VIEW_AD_AZEL)
braph2print(gui_bapf.get('PF').get('H'), [fileparts(fileparts(which('braph2'))) filesep 'SpreadingDynamics' filesep 'atlas_AD.jpg'], 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)
bapf.set('VIEW', BrainSurfacePF.VIEW_CA_AZEL)
braph2print(gui_bapf.get('PF').get('H'), [fileparts(fileparts(which('braph2'))) filesep 'SpreadingDynamics' filesep 'atlas_CA.jpg'], 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)

%% Load structural data
im_gr = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(fileparts(which('braph2'))) filesep 'SpreadingDynamics' filesep 'data' filesep 'DTI' filesep 'CN_neg' ...
    ''], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr = im_gr.get('GR');
g_dict = AnalyzeEnsemble_CON_WU('GR', gr).get('G_DICT');

%% Visualize structural Networks
gpf = GraphAdjPF('G', g_dict.get('IT', 1)); % change the idx to switch to other structural connectome
gui_g = GUIFig('PF', gpf);
gui_g.get('DRAW');
gui_g.get('SHOW')
braph2print(gui_g.get('PF').get('H'), [fileparts(fileparts(which('braph2'))) filesep 'NetworkModelling' filesep 'individual_structural_network.jpg'], 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)



%% Visualize SUVR for Amyloid and Tau

% Amyloid
cutoff = 1.3;
factor = 3;
facecolor = [0.5200, 0.0800, 0.0800];
visualize_pet_group(ba, 'Amyloid', 'CNn',  cutoff, factor, facecolor);
visualize_pet_group(ba, 'Amyloid', 'CNp', cutoff, factor, facecolor);
visualize_pet_group(ba, 'Amyloid', 'MCIp',  cutoff, factor, facecolor);
visualize_pet_group(ba, 'Amyloid', 'ADp',  cutoff, factor, facecolor);

%% Tau
cutoff = 1.1;
factor = 3;
facecolor = [0.0800, 0.2000, 0.5200] ;
visualize_pet_group(ba, 'Tau',     'CNn',  cutoff, factor, facecolor);
visualize_pet_group(ba, 'Tau',     'CNp', cutoff, factor, facecolor);
visualize_pet_group(ba, 'Tau',     'MCIp',  cutoff, factor, facecolor);
visualize_pet_group(ba, 'Tau',     'ADp',  cutoff, factor, facecolor);

%% GIF
% Make GIFs from static JPGs for Tau / Amyloid across views.
% Order: CNn -> CNp -> MCIp -> ADp
% Output: Tau_AD.gif, Tau_CA.gif, Tau_SL.gif, Amyloid_AD.gif, ...
%
% How to use:
%   1) Set inDir to the folder that contains your JPGs (e.g., .../SpreadingDynamics)
%   2) Set outDir for where you want the GIFs written (can be the same)
%   3) Run the script.

%% Config
inDir   = fullfile(fileparts(fileparts(which('braph2'))), 'SpreadingDynamics');
outDir  = inDir;                          % change if you like
delay   = 0.6;                             % seconds per frame
pingPong = false;                          % set true to go forward then backward
targetSize = [];                           % [] = keep native; or e.g. [1080 1080]

modalities = {'Tau','Amyloid'};
states     = {'CNn','CNp','MCIp','ADp'};
views      = {'AD','CA','SL'};            % AD = anterior–dorsal, CA = coronal–axial, SL = sagittal–lateral

if ~exist(outDir,'dir'); mkdir(outDir); end

%% Helper: full path for one frame
pathFrom = @(mod,st,vw) fullfile(inDir, sprintf('%s_%s_%s.jpg', mod, st, vw));

%% Helper: write a GIF from a list of image paths
function writeGifFromFrames(framePaths, outGif, delay, pingPong, targetSize)
    % Prepare frame list (optionally ping-pong)
    paths = framePaths(:);
    if pingPong && numel(paths) > 2
        paths = [paths; flip(paths(2:end-1))];
    end

    % Read first valid frame
    firstIdx = find(cellfun(@(p) exist(p,'file')==2, paths), 1, 'first');
    assert(~isempty(firstIdx), 'No existing frame files found for %s', outGif);

    A = imread(paths{firstIdx});
    if ~isempty(targetSize)
        A = imresize(A, targetSize);
    end
    [imind, cm] = rgb2ind(A, 256);
    imwrite(imind, cm, outGif, 'gif', 'Loopcount', inf, 'DelayTime', delay);

    % Append the rest
    for i = firstIdx+1:numel(paths)
        if exist(paths{i},'file') ~= 2
            warning('Missing frame (skipped): %s', paths{i});
            continue;
        end
        B = imread(paths{i});
        if ~isempty(targetSize)
            B = imresize(B, size(A,1:2));
        elseif ~isequal(size(B,1), size(A,1)) || ~isequal(size(B,2), size(A,2))
            % normalize size to first frame if different
            B = imresize(B, size(A,1:2));
        end
        [imind, cm] = rgb2ind(B, 256);
        imwrite(imind, cm, outGif, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
    end
end

%% Build GIFs
for m = 1:numel(modalities)
    mod = modalities{m};
    for v = 1:numel(views)
        vw = views{v};
        framePaths = cellfun(@(s) pathFrom(mod, s, vw), states, 'UniformOutput', false);
        outGif = fullfile(outDir, sprintf('%s_%s.gif', mod, vw));
        writeGifFromFrames(framePaths, outGif, delay, pingPong, targetSize);
        fprintf('Wrote %s\n', outGif);
    end
end

%% ---------- Helpers ----------
function file = find_group_file(base_dir, names)
    file = '';
    for i = 1:numel(names)
        cand = fullfile(base_dir, names{i});
        if exist(cand, 'file')
            file = cand;
            return
        end
    end
end

function tag = pretty_tag(group_tag)
    % ADp, MCIp, CNp, CNn → used in output filenames
    tag = group_tag;
end

function visualize_pet_group(ba, modality, group_tag, cutoff, factor, facecolor)
    % modality: 'Amyloid' or 'Tau'
    % group_tag: 'ADp','MCIp','CNp','CNn'
    % cutoff/factor as in your example (e.g., 1.1 and 3)
    data_root = fullfile(fileparts(fileparts(which('braph2'))), 'SpreadingDynamics','data');
    in_dir    = fullfile(data_root, ['PET ' upper(modality)]); % 'PET AMYLOID' or 'PET TAU'
    assert(isfolder(in_dir), 'Input folder not found: %s', in_dir);

    % Map group_tag → candidate filenames
    switch group_tag
        case 'ADp'
            candidates = {'AD_pos.xlsx','AD+.xlsx','ADp.xlsx'};
        case 'MCIp'
            candidates = {'MCI_pos.xlsx','MCI+.xlsx','MCIp.xlsx'};
        case 'CNp'
            candidates = {'CN_pos.xlsx','CN+.xlsx','CNp.xlsx'};
        case 'CNn'
            candidates = {'CN_neg.xlsx','CN-.xlsx','CNn.xlsx'};
        otherwise
            error('Unknown group tag: %s', group_tag);
    end

    in_file = find_group_file(in_dir, candidates);
    if isempty(in_file)
        warning('Skipping %s %s (no file: %s)', modality, group_tag, strjoin(candidates, ', '));
        return
    end

    % Import group
    im_gr = ImporterGroupSubjectST_XLS( ...
        'FILE', in_file, ...
        'BA',   ba, ...
        'WAITBAR', true ...
    );
    gr = im_gr.get('GR');

    % Collect SUVR into matrix (regions x subjects)
    sub_dict = gr.get('SUB_DICT');
    suvr_all = cellfun(@(sub) sub.get('ST'), sub_dict.get('IT_LIST'), 'UniformOutput', false);
    suvr_all = cell2mat(suvr_all);
    avg_suvr = mean(suvr_all, 2);

    % Threshold & magnify above cutoff
    avg_suvr(avg_suvr >  cutoff) = avg_suvr(avg_suvr >  cutoff) * factor;
    avg_suvr(avg_suvr <= cutoff) = 0.001;  % tiny spheres below/equal cutoff

    % ---- BRAPH2 brain surface plotting (same look & feel as your snippet) ----
    bapf = BrainAtlasPF('BA', ba);
    gui_bapf = GUIFig('PF', bapf, 'CLOSEREQ', false);
    gui_bapf.get('DRAW');
    gui_bapf.get('SHOW');

    bapf.get('ST_SURFACE').set('FACEALPHA', 0.6);
    bapf.get('ST_AMBIENT').set('CAMLIGHT', 'headlight');
    bapf.get('ST_AMBIENT').set('SHADING', 'interp');
    bapf.get('ST_AMBIENT').set('COLORMAP', 'white');
    bapf.get('ST_AMBIENT').set('COLORMAP', 'none');

    % Refresh spheres and set sizes
    bapf.set('SPHS', false);
    bapf.set('SPHS', true);
    sph_dict = bapf.get('SPH_DICT');
    for i = 1:numel(avg_suvr)
        sph_dict.get('IT', i).set('SPHERESIZE', avg_suvr(i));
        sph_dict.get('IT', i).set('FACECOLOR', facecolor);
    end

    % ---- Export three standard views ----
    contenttype = 'vector'; resolution = 300; colorspace = 'rgb';
    out_root = fullfile(fileparts(fileparts(which('braph2'))), 'SpreadingDynamics');
    tag = pretty_tag(group_tag);

    bapf.set('VIEW', BrainSurfacePF.VIEW_SL_AZEL)
    braph2print(gui_bapf.get('PF').get('H'), fullfile(out_root, sprintf('%s_%s_SL.jpg',  modality, tag)), 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)

    bapf.set('VIEW', BrainSurfacePF.VIEW_AD_AZEL)
    braph2print(gui_bapf.get('PF').get('H'), fullfile(out_root, sprintf('%s_%s_AD.jpg',  modality, tag)), 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)

    bapf.set('VIEW', BrainSurfacePF.VIEW_CA_AZEL)
    braph2print(gui_bapf.get('PF').get('H'), fullfile(out_root, sprintf('%s_%s_CA.jpg',  modality, tag)), 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)
    
    gui_bapf.get('CLOSE');
    % Optional: close GUI to avoid piling up windows
    try
        if ishghandle(gui_bapf.get('PF').get('H')); close(gui_bapf.get('PF').get('H')); end
    catch
    end
end
