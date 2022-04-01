classdef Plateforme < handle
    properties (Access=private)
       nbBanques = 0;
       tabBanques = Banque.empty();
    end

    methods (Access = public)
        function nouvellePlatforme = Plateforme()
            ChargerBaseDeDonnees();

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
        
        % Methode qui charge la base de donnees
        function ChargerBaseDeDonnees(obj)
	        
	        % Importer les constantes
	        ImporterConstantes
	        
	        % Fixer la semence aleatoire
	        rng(0)
	        
	        % Lire la base de donnees
	        FID = fopen(CHEMIN_BD, 'r');
	        texte = {};
	        while ~feof(FID)
		        texte{end + 1} = fgetl(FID); %#ok
	        end
	        fclose(FID);
	        
	        % Reconstruire la base de donnees
	        
	        % Le nombre de banques
	        temp = strsplit(texte{1}, ':');
	        nombreBanques = str2double(temp{end});
	        
	        % La ligne qui contient le nom de la banque
	        ligneNomBanque = 2;
	        
	        for i = 1 : nombreBanques
		        
		        % Nom de la banque
		        temp = strsplit(texte{ligneNomBanque}, ':');
		        nomBanque = strtrim(temp{end});
		        
		        % Numero d'institution de la banque
		        temp = strsplit(texte{ligneNomBanque + 1}, ':');
		        numeroInstitution = strtrim(temp{end});
		        
		        % Initialiser la banque
		        listeBanques(i) = Banque(nomBanque, numeroInstitution); %#ok
		        
		        % Le nombre de client de la banque
		        temp = strsplit(texte{ligneNomBanque + 2}, ':');
		        nbClients = str2double(temp{end});
		        
		        % La ligne qui contient le prÃ©nom du client
		        lignePrenomClient = ligneNomBanque + 5;
		        
		        for j = 1 : nbClients
			        
			        % Prenom du client
			        temp = strtrim(strsplit(texte{lignePrenomClient}, ':'));
			        prenom = temp{end};
			        
			        % Nom de famille du client
			        temp = strtrim(strsplit(texte{lignePrenomClient + 1}, ':'));
			        nom = temp{end};
			        
			        % Numero d'assurance sociale du client
			        temp = strtrim(strsplit(texte{lignePrenomClient + 2}, ':'));
			        numeroAssuranceSociale = temp{end};
			        
			        % Creer le client
			        unClient = Client(prenom, nom, numeroAssuranceSociale);
			        
			        % Nombre de comptes du client
			        temp = strsplit(texte{lignePrenomClient + 3}, ':');
			        nbComptes = str2double(temp{end});
			        
			        % La ligne qui contient le solde du comptes de cheques du client
			        ligneSoldeCheque = lignePrenomClient + 5;
			        
			        % Charger tous les comptes
			        for k = ligneSoldeCheque : 3 : ligneSoldeCheque + 3 * (nbComptes - 1)
				        
				        % Lire le solde du compte cheques
				        temp = strsplit(texte{k}, ':');
				        soldeCheque = str2double(temp{end});
				        
				        % Lire le solde du compte epargne
				        temp = strsplit(texte{k + 1}, ':');
				        soldeEpargne = str2double(temp{end});
				        
				        % Instancier le compte
				        unCompte = Compte(soldeCheque, soldeEpargne);
				        
				        % Le client est desormais le proprietaire du compte
				        %unCompte.proprietaire = unClient;
				        
				        % Ajouter le compte a la banque
				        listeBanques(i).AjouterCompte(unCompte, unClient);
				        
			        end
			        
			        % Ajouter le client a la banque
			        listeBanques(i).AjouterClient(unClient);
			        
			        % Ligne du prochain client
			        lignePrenomClient = k + 3;
			        
		        end
		        
		        % Ligne de la prochaine banque
		        ligneNomBanque = lignePrenomClient - 1;
		        
	        end
	        
	        % Enregistrer les parametres dans la plateforme
	        obj.nbBanques = nombreBanques;
	        obj.banques = listeBanques;
	         
        end

    end    
end