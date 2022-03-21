% MÃ©thode qui transforme un double en une chaÃ®ne de caractÃ¨res de
% format bancaire (i.e., #.## $)
function montantStr = TransformerFormatBancaire(montant)

    % Valider l'entrÃ©e
    validateattributes(montant, {'double'}, {'scalar'})

    % Isoler la partie entiÃ¨re et la partie dÃ©cimale
    partieEntiere = fix(montant);
    partieDecimale = montant - partieEntiere;

    montantStr = '';

    % Construire la partie entiÃ¨re chiffre par chiffre en ajoutant
    % un sÃ©parateur (i.e., une virgule) Ã  chaque 3 chiffres
    compteur = 0;
    while partieEntiere ~= 0
        chiffre = mod(partieEntiere, 10);
        if compteur == 3
            montantStr = [num2str(chiffre), ',', montantStr]; %#ok
            compteur = 1;
        else
            montantStr = [num2str(chiffre), montantStr]; %#ok
            compteur = compteur + 1;
        end
        partieEntiere = (partieEntiere - chiffre) / 10;
    end

    % Construire la partie dÃ©cimale
    partieDecimaleStr = num2str(partieDecimale * 100);

    if numel(partieDecimaleStr) == 1
        partieDecimaleStr = [partieDecimaleStr, '0'];
    end

    % Joindre la partie dÃ©cimale Ã  la partie entiÃ¨re
    montantStr = [montantStr, '.', partieDecimaleStr, ' $'];

end