classdef Plateforme < handle
    properties (Access=private)
       nbBanques = 0;
       tabBanques = Banque.empty();
    end

    methods (Access = public)
        function nouvellePlatforme = Plateforme()
            nouvellePlatforme.ChargerBaseDeDonnees();

        end

        function retour = getNbBanques(plateforme)
            retour = plateforme.nbBanques;
        end
        function AnalyserJournalTransactions(plateforme,nomFichier)
            validateattributes(nomFichier, {'char'},{'scalartext'});
            ImporterConstantes;
            noFichier = fopen([CHEMIN_DONNEES,'\',nomFichier]);
            
            assert(noFichier ~= -1,'Erreur d''ouverture de fichier.');

            while ~feof(noFichier)
                donnees = fscanf(noFichier,'%c%c%c,%c,%g,%c,%g',7);
                noInst = char.empty();
                noInst = [char(donnees(1)),char(donnees(2)),char(donnees(3))];
                typeTrans = char(donnees(4));
                idCompte = donnees(5);
                typeCompte = char(donnees(6));
                montant = donnees(7);
                EffectuerTransaction(plateforme, noInst,typeTrans,idCompte,typeCompte,montant);
            end

        end
        function GenererRapport(ref,nomFichier)
            if ~strcmp(nomFichier(end-3:end),'.txt')
                nomFichier = [nomFichier,'.txt'];
            end
            ImporterConstantes;
            noFichier = fopen([CHEMIN_RAPPORTS,'\',nomFichier],'w');
            assert(noFichier ~= -1,'Erreur d''ouverture de fichier.');
            
            
            for i=1:size(ref.tabBanques, 2)
                fprintf(noFichier,'Banque numéro: %g\n\n',i);
                fprintf(noFichier,'	Nom               : %s\n',ref.tabBanques(i).getNom());
                fprintf(noFichier,'	No. institution   : %s\n',ref.tabBanques(i).getNumero());
                fprintf(noFichier,'	Nombre de clients : %03g\n',ref.tabBanques(i).getNbClient());
                fprintf(noFichier,'	Nombre de comptes : %03g\n\n',ref.tabBanques(i).getNbCompte());
                fprintf(noFichier,'    Détails des comptes clients :\n\n');

                for j=1:ref.tabBanques(i).getNbClient()
                    fprintf(noFichier,'		Client No. %g\n\n',j);
                    fprintf(noFichier,'			Prénom : %s\n', ref.tabBanques(i).ObtenirClient(j).getPrenom());
                    fprintf(noFichier,'			Nom     : %s\n\n', ref.tabBanques(i).ObtenirClient(j).getNom());
                    totalCheques = 0;
                    totalEpargne = 0;
                    for k=1:ref.tabBanques(i).ObtenirClient(j).getNbComptes()
                        fprintf(noFichier,'					Identifiant    : %s\n',ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getIdentifiant());
                        soldeCheque = TransformerFormatBancaire(ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeCheque());
                        totalCheques = totalCheques + ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeCheque();
                        soldeEpargne = TransformerFormatBancaire(ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeEpargne());
                        totalEpargne = totalEpargne + ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeEpargne();
                        fprintf(noFichier,'					Solde cheques  : %s\n',soldeCheque);
                        fprintf(noFichier,'					Solde epargnes : %s\n\n',soldeEpargne);
                    end
                    fprintf(noFichier,'			Total cheques : %s\n',TransformerFormatBancaire(totalCheques));
                    fprintf(noFichier,'			Total epargne : %s\n\n',TransformerFormatBancaire(totalEpargne));
                end
            end
        fclose(noFichier); 
        end
        
        function EffectuerTransaction(ref,numInst,typeTrans,id,typeCompte,montant)
            i=1;
            while ~strcmp(ref.tabBanques(i).getNumero,(numInst))
                i= i+1;
            end
           
            if typeTrans == 'D'
                if typeCompte == 'C'
                    DepotCheques(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                elseif typeCompte == 'E'
                    DepotEpargne(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                end   
            elseif typeTrans == 'R'
                if typeCompte == 'C'
                    RetraitCheques(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                elseif typeCompte == 'E'
                    RetraitEpargne(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                end  
            end
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
	        obj.tabBanques = listeBanques;
	         
        end
        
    end    
end