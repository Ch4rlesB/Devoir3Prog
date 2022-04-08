function ProgrammePrincipal()
    %% Général
    % Configurer le projet (constante, etc.)
    ConfigurerProjet

    %% Main

    %Execution des etapes requises (creation d'une plateforme, generation
    %du rapport, analyse des transactions, generation d'un second rapport.
    plateforme = Plateforme();
    plateforme.GenererRapport('RapportAvant');
    plateforme.AnalyserJournalTransactions('Transactions.txt');
    plateforme.GenererRapport('RapportApres');

end