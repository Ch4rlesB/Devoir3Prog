function ConfigurerProjet()

    % Importer les constantes du projet
    ImporterConstantes
    
    % Ajouter les accès
    addpath(CHEMIN_DONNEES)
    addpath(CHEMIN_RAPPORTS)
    addpath(CHEMIN_MODULES)
    
    addpath(CHEMIN_MOD_CLIENT)
    addpath(CHEMIN_MOD_PLATEFORME)
    addpath(CHEMIN_MOD_COMPTE)
    addpath(CHEMIN_MOD_BANQUE)
    addpath(CHEMIN_MOD_OUTILS)

    % Ajouter l'accès au fichier courant
    addpath(pwd)

end