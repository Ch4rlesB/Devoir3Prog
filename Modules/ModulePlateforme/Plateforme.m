classdef Plateforme < handle
    properties (Access=private)
       nbBanques = 0;
       tabBanques = Banque.empty();
    end

    methods (Access = public)
        function nouvellePlatforme = Plateforme()
            %ChargerBaseDeDonnees();

        end

        function retour = getNbBanques(plateforme)
            retour = plateforme.nbBanques;
        end
        function AnalyserJournalTransactions(plateforme,nomFichier)
            validateattributes(nomFichier, {'char'},{'scalartext'});
            
            noFichier = fopen([CHEMIN_DONNEES,nomFichier]);
            
            assert(noFichier ~= -1,'Erreur d''ouverture de fichier.');

            while ~feof(noFichier)
                donnees = fscanf(noFichier,'%g,%c,%g,%c,%g',5);
                noInst = donnees(1);
                typeTrans = num2str(donnees(2));
                idCompte = donnees(3);
                typeCompte = num2str(donnees(4));
                montant = donnees(5);
                EffectuerTransaction(plateforme, noInst,typeTrans,idCompte,typeCompte,montant);
            end

        end
        function GenererRapport(plateforme,nomFichier)
            if ~strcmp(nomFichier(end-3:end),'.txt')
                nomFichier = [nomFichier,'.txt'];
            end
            
            noFichier = fopen([CHEMIN_RAPPORTS,nomFichier]);
            assert(noFichier ~= -1,'Erreur d''ouverture de fichier.');


        end
        
        % Méthode qui charge la base de données
        function ChargerBaseDeDonnees(obj)
                   
            % Charger la base de données dans l'espace de travail
            load('BaseDeDonnees', 'listeBanques')
                    
            % Stocker la base de données dans l'objet
            obj.tabBanques = listeBanques;
                    
            % Stocker le nombre de banques dans la base de données
            obj.nbBanques = numel(listeBanques);
                    
        end

    end    
end