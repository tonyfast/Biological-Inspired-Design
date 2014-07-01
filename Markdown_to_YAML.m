%% Sample File

filename = 'Comparison Characteristics.md';


%%

genus = {'Wood Pecker Scull', ...
    'Toucan Beak',...
    'Articular Cartilage'};

%% Read File
% Read the salient lines of the markdown file to convert into a yaml file.

fo = fopen( filename );
[ct, ctwhile, headct] = deal(0);
[s, s2, header] = deal(cell(1));

while ~feof( fo )
    ctwhile = ctwhile + 1;
    
    s{ctwhile} = fgetl( fo );
    if numel( s{ctwhile} ) > 0 && s{ctwhile}(1) == '#'
        ct = ct + 1;
        s2{ct} = strtrim(regexprep( s{ctwhile}, '#',' '));
    elseif numel( s{ctwhile} ) > 0 && all(s{ctwhile}=='-')
        headct = headct + 1;
        header{headct} = regexprep( s{ctwhile-1}, ' ', '_' );
        header{headct} = regexprep( header{headct}, '''', '' );
    else
        % Don't do anything
    end
end
fclose( fo )

% Remove first line of Comparison Characteristics.md, it is not relevent

header(1) = [];

%% YAML Structure
% Convert Scraped markdown in YAML format to use with YAML toolbox 
% <https://code.google.com/p/yamlmatlab/ YAML matlab>

data = struct();
for ii = 1 : numel( header )
    data = setfield( data, header{ii}, struct() );
    
    for jj = 1 : 2 : 6
        id = (ii-1) * 6 + jj
        fld = regexprep( s2{id}, ' ','_');
        data.(header{ii}) = setfield( data.(header{ii}), fld, s2{id+1})
    end
        
end

WriteYaml('Comparison.yaml', data, 1)

%% I don't like the formatting of the YAML code.
% Hack up my own


yamlfile = 'Comparison.yaml';
fo = fopen( yamlfile,'w' );
for ii = 1 : numel( header )
    fprintf( fo,'%s:\n', header{ii} );
    
    for jj = 1 : 2 : 6
        id = (ii-1) * 6 + jj
        fld = regexprep( s2{id}, ' ','_');
        fprintf(fo, '- %s:\n', fld );
        fprintf(fo, '  - %s\n', s2{id+1} );
    end
        
end

fclose( fo )

%% Codify the fields



alias = {'woodpecker',...
    'toucan',...
    'articular_cat' }

data = struct( alias{1}, struct, ...
    alias{2}, struct, ...
    alias{3}, struct) 