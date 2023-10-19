select
    /*+ NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX) NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX) */
    UNION_FINALE.CODICE_SOTTOSISTEMA AS CODICE_SOTTOSISTEMA,
    UNION_FINALE.PROVINCIA_EMISSIONE AS PROVINCIA_EMISSIONE,
    UNION_FINALE.CODICE_PRODOTTO AS CODICE_PRODOTTO,
    UNION_FINALE.FIGURA_FISCALE AS FIGURA_FISCALE,
    UNION_FINALE.DATA_EMISSIONE AS DATA_EMISSIONE,
    UNION_FINALE.DIVISA AS DIVISA,
    UNION_FINALE.TAGLIO AS TAGLIO,
    UNION_FINALE.SERIE AS SERIE,
    UNION_FINALE.REGIME_FISCALE AS REGIME_FISCALE,
    UNION_FINALE.NUMERO_LIBRETTI AS NUMERO_LIBRETTI,
    UNION_FINALE.CAPITALE AS CAPITALE,
    UNION_FINALE.RATEO_INTERESSI AS RATEO_INTERESSI,
    UNION_FINALE.PRV_ID AS PRV_ID,
    UNION_FINALE.PRD_ID_1 AS PRD_ID,
    UNION_FINALE.TGL_ID AS TGL_ID,
    UNION_FINALE.TPS_COD AS TPS_COD,
    UNION_FINALE.TPS_ID AS TPS_ID,
    UNION_FINALE.DATA_RIFERIMENTO_WORK AS DATA_INSERIMENTO,
    UNION_FINALE.DVS_ID AS DVS_ID,
    UNION_FINALE.COD_PROPRIETARIO AS COD_PROPRIETARIO,
    UNION_FINALE.ID_PROPRIETARIO AS ID_PROPRIETARIO,
    UNION_FINALE.FSC_ID AS FSC_ID,
    UNION_FINALE.RGN_COD AS RGN_COD,
    UNION_FINALE.INT_BP_CONT_GIORN AS INTERESSE_GIORNALIERO,
    UNION_FINALE.INTERESSE_MENSILE AS INTERESSE_MENSILE,
    UNION_FINALE.INTERESSE_TOTALE AS INTERESSE_TOTALE,
    UNION_FINALE.SERIE_DWH AS SERIE_DWH,
    UNION_FINALE.INT_BP_LIQ_LORDI AS INTERESSE_BP_LIQ_LORDO,
    case
        when UNION_FINALE.FIGURA_FISCALE = 'L' then UNION_FINALE.INT_BP_LIQ_LORDI
        else UNION_FINALE.INT_BP_LIQ_NETTI
    end AS INTERESSE_BP_LIQ_NETTO,
    UNION_FINALE.INT_BP_CONT_SP AS INTERESSE_BP_CONT_SP,
    UNION_FINALE.INT_BP_CAP AS INTERESSE_BP_CAP,
    UNION_FINALE.INT_LIQ_LORDI_GG AS INTERESSE_BP_LIQ_LORDO_GG,
    UNION_FINALE.CAPITALE_PREMIO_TOT AS CAPITALE_PREMIO_TOT,
    UNION_FINALE.CAPITALE_PREMIO_OPZ AS CAPITALE_PREMIO_OPZ,
    UNION_FINALE.INT_LIQ_BASE_LORDI AS INTERESSE_BP_LIQ_BASE_LORDO,
    UNION_FINALE.INT_LIQ_BASE_NETTI AS INTERESSE_BP_LIQ_BASE_NETTO,
    UNION_FINALE.CAPITALE_NOMINALE AS CAPITALE_NOMINALE,
    UNION_FINALE.DATA_SCADENZA_BP AS DATA_SCADENZA_BP,
    UNION_FINALE.GIACENZA AS GIACENZA,
    UNION_FINALE.DATA_NASCITA AS DATA_NASCITA,
    UNION_FINALE.ID_CANALE_VENDITA AS ID_CANALE_VENDITA
from
    (
        SELECT
            TMP_WORK_PRD_GIORNO_EXC.CODICE_SOTTOSISTEMA AS CODICE_SOTTOSISTEMA,
            TMP_WORK_PRD_GIORNO_EXC.PROVINCIA_EMISSIONE AS PROVINCIA_EMISSIONE,
            TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO AS CODICE_PRODOTTO,
            TMP_WORK_PRD_GIORNO_EXC.FIGURA_FISCALE AS FIGURA_FISCALE,
            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE AS DATA_EMISSIONE,
            TMP_WORK_PRD_GIORNO_EXC.DIVISA AS DIVISA,
            TMP_WORK_PRD_GIORNO_EXC.TAGLIO AS TAGLIO,
            TMP_WORK_PRD_GIORNO_EXC.SERIE AS SERIE,
            TMP_WORK_PRD_GIORNO_EXC.REGIME_FISCALE AS REGIME_FISCALE,
            TMP_WORK_PRD_GIORNO_EXC.NUMERO_LIBRETTI AS NUMERO_LIBRETTI,
            TMP_WORK_PRD_GIORNO_EXC.CAPITALE AS CAPITALE,
            TMP_WORK_PRD_GIORNO_EXC.RATEO_INTERESSI AS RATEO_INTERESSI,
            TMP_WORK_PRD_GIORNO_EXC.PRV_ID AS PRV_ID,
            TMP_WORK_PRD_GIORNO_EXC.PRD_ID_1 AS PRD_ID_1,
            TMP_WORK_PRD_GIORNO_EXC.TGL_ID AS TGL_ID,
            TMP_WORK_PRD_GIORNO_EXC.TPS_COD AS TPS_COD,
            TMP_WORK_PRD_GIORNO_EXC.TPS_ID AS TPS_ID,
            (
                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                    (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365
                )
            ) AS INT_BP_CONT_GIORN,
            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK AS DATA_RIFERIMENTO_WORK,
            (
                case
                    when to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        'yyyymm'
                    ) = to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'yyyymm'
                    ) then (
                        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                            (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365
                        )
                    ) + TMP_WORK_PRD_GIORNO_EXC.INTERESSE_MENSILE
                    else (
                        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                            (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365
                        )
                    )
                end
            ) AS INTERESSE_MENSILE,
            (
                case
                    when to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        'yyyy'
                    ) = to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'yyyy'
                    ) then TMP_WORK_PRD_GIORNO_EXC.INTERESSE_TOTALE + TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365
                    )
                    else TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365
                    )
                end
            ) AS INTERESSE_TOTALE,
            TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH AS SERIE_DWH,
            TMP_WORK_PRD_GIORNO_EXC.DVS_ID AS DVS_ID,
            TMP_WORK_PRD_GIORNO_EXC.COD_PROPRIETARIO AS COD_PROPRIETARIO,
            TMP_WORK_PRD_GIORNO_EXC.ID_PROPRIETARIO AS ID_PROPRIETARIO,
            TMP_WORK_PRD_GIORNO_EXC.FSC_ID AS FSC_ID,
            TMP_WORK_PRD_GIORNO_EXC.RGN_COD AS RGN_COD,
            0 AS INT_BP_LIQ_LORDI,
            0 AS INT_BP_LIQ_NETTI,
            (
                case
                    when to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        'yyyy'
                    ) = to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'yyyy'
                    ) then TMP_WORK_PRD_GIORNO_EXC.INTERESSE_BP_CONT_SP + TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        (
                            (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365 * (
                                (
                                    100 - (TMP_WORK_PRD_GIORNO_EXC.PRD_ALQ_REN * 100)
                                ) / 100
                            )
                        )
                    ) - TMP_WORK_PRD_GIORNO_EXC.RATEO_INTERESSE_GIORN
                    else TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        (
                            (TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE) / 365 * (
                                (
                                    100 - (TMP_WORK_PRD_GIORNO_EXC.PRD_ALQ_REN * 100)
                                ) / 100
                            )
                        )
                    ) - TMP_WORK_PRD_GIORNO_EXC.RATEO_INTERESSE_GIORN
                END
            ) AS INT_BP_CONT_SP,
            0 AS INT_BP_CAP,
            0 AS INT_LIQ_LORDI_GG,
            0 AS CAPITALE_PREMIO_TOT,
            0 AS INT_LIQ_BASE_LORDI,
            0 AS INT_LIQ_BASE_NETTI,
            0 AS CAPITALE_PREMIO_OPZ,
            TMP_WORK_PRD_GIORNO_EXC.CAPITALE_NOMINALE AS CAPITALE_NOMINALE,
            TMP_WORK_PRD_GIORNO_EXC.DATA_SCADENZA_BP AS DATA_SCADENZA_BP,
            TMP_WORK_PRD_GIORNO_EXC.GIACENZA AS GIACENZA,
            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA AS DATA_NASCITA,
            TMP_WORK_PRD_GIORNO_EXC.ID_CANALE_VENDITA AS ID_CANALE_VENDITA
        FROM
            CDP_DWH.TMP_WORK_PRD_GIORNO_EXC TMP_WORK_PRD_GIORNO_EXC
            INNER JOIN CDP_ANAG.META_SCTG_FASCE @LCDP_ANAG META_SCTG_FASCE ON TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = META_SCTG_FASCE.SCTG_COD
        WHERE
            (
                TMP_WORK_PRD_GIORNO_EXC.CODICE_SOTTOSISTEMA = 'DR'
                AND NOT (
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE = '0'
                    and to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'mmdd'
                    ) = '0101'
                )
            )
        UNION
        ALL
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX)    NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX)    NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX)  */
            TMP_WORK_PRD_GIORNO_EXC.CODICE_SOTTOSISTEMA AS CODICE_SOTTOSISTEMA,
            TMP_WORK_PRD_GIORNO_EXC.PROVINCIA_EMISSIONE AS PROVINCIA_EMISSIONE,
            TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO AS CODICE_PRODOTTO,
            TMP_WORK_PRD_GIORNO_EXC.FIGURA_FISCALE AS FIGURA_FISCALE,
            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE AS DATA_EMISSIONE,
            TMP_WORK_PRD_GIORNO_EXC.DIVISA AS DIVISA,
            TMP_WORK_PRD_GIORNO_EXC.TAGLIO AS TAGLIO,
            TMP_WORK_PRD_GIORNO_EXC.SERIE AS SERIE,
            TMP_WORK_PRD_GIORNO_EXC.REGIME_FISCALE AS REGIME_FISCALE,
            TMP_WORK_PRD_GIORNO_EXC.NUMERO_LIBRETTI AS NUMERO_LIBRETTI,
            TMP_WORK_PRD_GIORNO_EXC.CAPITALE AS CAPITALE,
            TMP_WORK_PRD_GIORNO_EXC.RATEO_INTERESSI AS RATEO_INTERESSI,
            TMP_WORK_PRD_GIORNO_EXC.PRV_ID AS PRV_ID,
            TMP_WORK_PRD_GIORNO_EXC.PRD_ID_1 AS PRD_ID_1,
            TMP_WORK_PRD_GIORNO_EXC.TGL_ID AS TGL_ID,
            TMP_WORK_PRD_GIORNO_EXC.TPS_COD AS TPS_COD,
            TMP_WORK_PRD_GIORNO_EXC.TPS_ID AS TPS_ID,
            (
                CASE
                    WHEN CASE
                        WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN' THEN to_number(
                            CASE
                                WHEN months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) < 780 THEN trunc(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    ) / 12
                                ) || lpad(
                                    trunc(
                                        mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            ),
                                            12
                                        )
                                    ),
                                    2,
                                    '0'
                                )
                                WHEN months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) >= 780 THEN TRUNC(
                                    10.5 + (
                                        0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                                    )
                                ) + trunc(
                                    LPAD(
                                        CASE
                                            WHEN MOD(
                                                TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                                2
                                            ) = 0 THEN 0.5
                                            ELSE 0
                                        END + (
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                            ) - 780
                                        ),
                                        2,
                                        '0'
                                    ) / 12
                                ) || LPAD(
                                    mod(
                                        CASE
                                            WHEN MOD(
                                                TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                                2
                                            ) = 0 THEN 5
                                            ELSE 0
                                        END + (
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                            ) - 780
                                        ),
                                        12
                                    ),
                                    2,
                                    '0'
                                )
                            END
                        )
                        ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
                    END = 0 THEN 0
                    ELSE CASE
                        WHEN TO_CHAR(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                            'MMDD'
                        ) = '0301' THEN CASE
                            WHEN TO_CHAR(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -1,
                                'DD'
                            ) = '29' THEN (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO * 2 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                            ELSE (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO * 3 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        END
                        ELSE CASE
                            WHEN TO_CHAR(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                'DD'
                            ) = '31' THEN 0
                            ELSE (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        END
                    END
                END
            ) AS INT_BP_CONT_GIORN,
            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK AS DATA_RIFERIMENTO_WORK,
            TMP_WORK_PRD_GIORNO_EXC.INTERESSE_MENSILE AS INTERESSE_MENSILE,
            (
                TMP_WORK_PRD_GIORNO_EXC.INTERESSE_TOTALE + CASE
                    WHEN CASE
                        WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN' THEN to_number(
                            CASE
                                WHEN months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) < 780 THEN trunc(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    ) / 12
                                ) || lpad(
                                    trunc(
                                        mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            ),
                                            12
                                        )
                                    ),
                                    2,
                                    '0'
                                )
                                WHEN months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) >= 780 THEN TRUNC(
                                    10.5 + (
                                        0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                                    )
                                ) + trunc(
                                    LPAD(
                                        CASE
                                            WHEN MOD(
                                                TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                                2
                                            ) = 0 THEN 0.5
                                            ELSE 0
                                        END + (
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                            ) - 780
                                        ),
                                        2,
                                        '0'
                                    ) / 12
                                ) || LPAD(
                                    mod(
                                        CASE
                                            WHEN MOD(
                                                TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                                2
                                            ) = 0 THEN 5
                                            ELSE 0
                                        END + (
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                            ) - 780
                                        ),
                                        12
                                    ),
                                    2,
                                    '0'
                                )
                            END
                        )
                        ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
                    END = 0 THEN 0
                    ELSE CASE
                        WHEN TO_CHAR(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                            'MMDD'
                        ) = '0301' THEN CASE
                            WHEN TO_CHAR(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -1,
                                'DD'
                            ) = '29' THEN (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO * 2 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                            ELSE (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO * 3 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        END
                        ELSE CASE
                            WHEN TO_CHAR(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                'DD'
                            ) = '31' THEN 0
                            ELSE (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        END
                    END
                END
            ) AS INTERESSE_TOTALE,
            TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH AS SERIE_DWH,
            TMP_WORK_PRD_GIORNO_EXC.DVS_ID AS DVS_ID,
            TMP_WORK_PRD_GIORNO_EXC.COD_PROPRIETARIO AS COD_PROPRIETARIO,
            TMP_WORK_PRD_GIORNO_EXC.ID_PROPRIETARIO AS ID_PROPRIETARIO,
            TMP_WORK_PRD_GIORNO_EXC.FSC_ID AS FSC_ID,
            TMP_WORK_PRD_GIORNO_EXC.RGN_COD AS RGN_COD,
            (
                (
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_LORDO
                ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
            ) AS INT_BP_LIQ_LORDI,
            (
                (
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_NETTO
                ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
            ) AS INT_BP_LIQ_NETTI,
            (
                CASE
                    WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN' THEN to_number(
                        CASE
                            WHEN months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                            ) < 780 THEN trunc(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ) / 12
                            ) || lpad(
                                trunc(
                                    mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        ),
                                        12
                                    )
                                ),
                                2,
                                '0'
                            )
                            WHEN months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                            ) >= 780 THEN TRUNC(
                                10.5 + (
                                    0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                                )
                            ) + trunc(
                                LPAD(
                                    CASE
                                        WHEN MOD(
                                            TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                            2
                                        ) = 0 THEN 0.5
                                        ELSE 0
                                    END + (
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                        ) - 780
                                    ),
                                    2,
                                    '0'
                                ) / 12
                            ) || LPAD(
                                mod(
                                    CASE
                                        WHEN MOD(
                                            TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                            2
                                        ) = 0 THEN 5
                                        ELSE 0
                                    END + (
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                        ) - 780
                                    ),
                                    12
                                ),
                                2,
                                '0'
                            )
                        END
                    )
                    ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
                END = 0 THEN
                /* il buono è in prescrizione o prescritto*/
                CASE
                    WHEN CASE
                        WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN' THEN to_number(
                            CASE
                                WHEN months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) < 780 THEN trunc(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    ) / 12
                                ) || lpad(
                                    trunc(
                                        mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            ),
                                            12
                                        )
                                    ),
                                    2,
                                    '0'
                                )
                                WHEN months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) >= 780 THEN TRUNC(
                                    10.5 + (
                                        0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                                    )
                                ) + trunc(
                                    LPAD(
                                        CASE
                                            WHEN MOD(
                                                TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                                2
                                            ) = 0 THEN 0.5
                                            ELSE 0
                                        END + (
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                            ) - 780
                                        ),
                                        2,
                                        '0'
                                    ) / 12
                                ) || LPAD(
                                    mod(
                                        CASE
                                            WHEN MOD(
                                                TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                                2
                                            ) = 0 THEN 5
                                            ELSE 0
                                        END + (
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                            ) - 780
                                        ),
                                        12
                                    ),
                                    2,
                                    '0'
                                )
                            END
                        )
                        ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BUONO
                    END = 0 THEN
                    /*il buono è prescritto*/
                    0
                    ELSE
                    /* il buono è in prescrizione*/
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                END
                ELSE
                /* il buono è in vita*/
                case
                    when to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') < 17 then
                    /* (in questo caso l'anzianita considerata è stata approssimata al mese per eccesso), per cui è necessario
                     considerare tanti giorni del bimestre in corso quanti sono: data_rimb-(data_em + annimesiinizioanz -(giorno_em-1))*/
                    (
                        CASE
                            WHEN TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                                (
                                    ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        SUBSTR(
                                            LPAD(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + SUBSTR(
                                            LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            -2
                                        )
                                    )
                                ) -(
                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                )
                            ) = 0 THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                            ELSE
                            /*interesse bimestre concluso + interesse bimestre parziale in corso*/
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE + (
                                (
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                                        (
                                            ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            )
                                        ) -(
                                            to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                        )
                                    ) - nvl(
                                        LENGTH(
                                            CASE
                                                WHEN TO_DATE(
                                                    '3101' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3103' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3105' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3107' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3108' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3110' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3110' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ) -1,
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3112' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3112' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ) -1,
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) -(
                                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                                ) + 1
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END
                                        ),
                                        0
                                    ) + CASE
                                        WHEN TO_DATE(
                                            '0103' || TO_CHAR(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN ADD_MONTHS(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            SUBSTR(
                                                LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                1,
                                                2
                                            ) * 12 + SUBSTR(
                                                LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                -2
                                            )
                                        ) -(
                                            to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') -1
                                        ) + 1
                                        AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN CASE
                                            WHEN TO_CHAR(
                                                TO_DATE(
                                                    '0103' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ),
                                                'DD'
                                            ) = '28' THEN 2
                                            ELSE 1
                                        END
                                        ELSE 0
                                    END
                                ) * TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        end
                    )
                    else
                    /*giorno emissione >= 17 */
                    /* (in questo caso l'anzianita considerata è stata approssimata al mese per difetto), per cui è necessario
                     considerare tanti giorni del bimestre in corso quanti sono: data_rimb-(data_em + annimesiinizioanz +(30-giorno_em+1))*/
                    (
                        CASE
                            WHEN TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                                (
                                    ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        SUBSTR(
                                            LPAD(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + SUBSTR(
                                            LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            -2
                                        )
                                    )
                                ) +(
                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                )
                            ) = 0 THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                            ELSE
                            /*interesse bimestre concluso + interesse bimestre parziale in corso*/
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE + (
                                (
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                                        (
                                            ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            )
                                        ) +(
                                            30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                        )
                                    ) - nvl(
                                        LENGTH(
                                            CASE
                                                WHEN TO_DATE(
                                                    '3101' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3103' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3105' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3107' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3108' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3110' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3110' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ) -1,
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3112' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END || CASE
                                                WHEN TO_DATE(
                                                    '3112' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ) -1,
                                                    'DDMMYYYY'
                                                ) BETWEEN ADD_MONTHS(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                    SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        1,
                                                        2
                                                    ) * 12 + SUBSTR(
                                                        LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                        -2
                                                    )
                                                ) +(
                                                    30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                                )
                                                AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                                ELSE NULL
                                            END
                                        ),
                                        0
                                    ) + CASE
                                        WHEN TO_DATE(
                                            '0103' || TO_CHAR(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN ADD_MONTHS(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            SUBSTR(
                                                LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                1,
                                                2
                                            ) * 12 + SUBSTR(
                                                LPAD(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                -2
                                            )
                                        ) +(
                                            30 - to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') + 1
                                        )
                                        AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN CASE
                                            WHEN TO_CHAR(
                                                TO_DATE(
                                                    '0103' || TO_CHAR(
                                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                        'YYYY'
                                                    ),
                                                    'DDMMYYYY'
                                                ) -1,
                                                'DD'
                                            ) = '28' THEN 2
                                            ELSE 1
                                        END
                                        ELSE 0
                                    END
                                ) * TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_1.IMPORTO_CONT_LORDO / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        end
                    )
                end
            end
    ) AS INT_BP_CONT_SP,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_VT_PR = 1 then TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(WORK_PRONT_BP_SPEC_3.IMPORTO_LIQ_LORDO -1)
            else 0
        end
    ) AS INT_BP_CAP,
    (
        CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO = 0 THEN CASE
                WHEN TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_VT_PR = 0 THEN 0
                ELSE TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
            END
            ELSE CASE
                WHEN TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK - (
                    add_months(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                        substr(
                            lpad(
                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                4,
                                '0'
                            ),
                            1,
                            2
                        ) * 12 + substr(
                            lpad(
                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                4,
                                '0'
                            ),
                            - 2
                        )
                    )
                ) = 0 THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                ELSE
                /*interesse bimestre concluso + interesse bimestre parziale in corso*/
                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE + (
                    (
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK - (
                            add_months(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                substr (
                                    lpad(
                                        WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                        4,
                                        '0'
                                    ),
                                    1,
                                    2
                                ) * 12 + substr (
                                    lpad (
                                        WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                        4,
                                        '0'
                                    ),
                                    - 2
                                )
                            )
                        ) - nvl (
                            length (
                                CASE
                                    WHEN TO_DATE(
                                        '3101' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3103' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3105' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3107' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3108' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3110' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3110' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ) - 1,
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3112' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END || CASE
                                    WHEN TO_DATE(
                                        '3112' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ) - 1,
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            1,
                                            2
                                        ) * 12 + substr(
                                            lpad(
                                                WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                                4,
                                                '0'
                                            ),
                                            - 2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                    ELSE NULL
                                END
                            ),
                            0
                        ) + CASE
                            WHEN TO_DATE(
                                '0103' || to_char(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                    'YYYY'
                                ),
                                'DDMMYYYY'
                            ) BETWEEN add_months(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                substr(
                                    lpad(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                    1,
                                    2
                                ) * 12 + substr (
                                    lpad(WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                    - 2
                                )
                            ) + 1
                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN CASE
                                WHEN to_char(
                                    TO_DATE(
                                        '0103' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) - 1,
                                    'DD'
                                ) = '28' THEN 2
                                ELSE 1
                            END
                            ELSE 0
                        END
                    ) * TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        WORK_PRONT_BP_SPEC_1.IMPORTO_LIQ_LORDO - WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_LORDO
                    ) / decode(
                        add_months(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                            substr(
                                lpad(
                                    WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                    4,
                                    '0'
                                ),
                                1,
                                2
                            ) * 12 + substr (
                                lpad (
                                    WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ,
                                    4,
                                    '0'
                                ),
                                - 2
                            )
                        ),
                        last_day(
                            TO_DATE(
                                '0102' | | to_char (
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                    'yyyy'
                                ),
                                'ddmmyyyy'
                            )
                        ),
                        TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP + least(
                            2,
                            to_char (TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') - to_char (
                                last_day (
                                    TO_DATE (
                                        '0102' | | to_char (
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'yyyy'
                                        ),
                                        'ddmmyyyy'
                                    )
                                ),
                                'dd'
                            )
                        ),
                        TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                    )
                )
            END
        END
    ) AS INT_LIQ_LORDI_GG,
    0 AS CAPITALE_PREMIO_TOT,
    (
        (
            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_LORDO
        ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
    ) AS INT_LIQ_BASE_LORDI,
    (
        (
            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_SPEC_2.IMPORTO_LIQ_NETTO
        ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
    ) AS INT_LIQ_BASE_NETTI,
    0 AS CAPITALE_PREMIO_OPZ,
    TMP_WORK_PRD_GIORNO_EXC.CAPITALE_NOMINALE AS CAPITALE_NOMINALE,
    TMP_WORK_PRD_GIORNO_EXC.DATA_SCADENZA_BP AS DATA_SCADENZA_BP,
    TMP_WORK_PRD_GIORNO_EXC.GIACENZA AS GIACENZA,
    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA AS DATA_NASCITA,
    TMP_WORK_PRD_GIORNO_EXC.ID_CANALE_VENDITA AS ID_CANALE_VENDITA
FROM
    (
        CDP_DWH.TMP_WORK_PRD_GIORNO_EXC TMP_WORK_PRD_GIORNO_EXC
        INNER JOIN CDP_ANAG.META_SCTG_FASCE @LCDP_ANAG META_SCTG_FASCE ON TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = META_SCTG_FASCE.SCTG_COD
    ),
    (
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX)  */
            WORK_PRONT_BP_SPEC.SERIE AS SERIE,
            WORK_PRONT_BP_SPEC.DATA_EMISSIONE AS DATA_EMISSIONE,
            WORK_PRONT_BP_SPEC.ANNI_MESI_INIZIO_ANZ AS ANNI_MESI_INIZIO_ANZ,
            WORK_PRONT_BP_SPEC.ANNI_MESI_FINE_ANZ AS ANNI_MESI_FINE_ANZ,
            WORK_PRONT_BP_SPEC.IMPORTO_LIQ_LORDO AS IMPORTO_LIQ_LORDO,
            WORK_PRONT_BP_SPEC.IMPORTO_CONT_LORDO AS IMPORTO_CONT_LORDO
        FROM
            CDP_DWH.WORK_PRONT_BP_SPEC WORK_PRONT_BP_SPEC
    ) WORK_PRONT_BP_SPEC_1,
    (
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX)  */
            WORK_PRONT_BP_SPEC.SERIE AS SERIE,
            WORK_PRONT_BP_SPEC.DATA_EMISSIONE AS DATA_EMISSIONE,
            WORK_PRONT_BP_SPEC.ANNI_MESI_INIZIO_ANZ AS ANNI_MESI_INIZIO_ANZ,
            WORK_PRONT_BP_SPEC.ANNI_MESI_FINE_ANZ AS ANNI_MESI_FINE_ANZ,
            WORK_PRONT_BP_SPEC.IMPORTO_LIQ_LORDO AS IMPORTO_LIQ_LORDO,
            WORK_PRONT_BP_SPEC.IMPORTO_LIQ_NETTO AS IMPORTO_LIQ_NETTO,
            WORK_PRONT_BP_SPEC.IMPORTO_CONT_LORDO_TOT AS IMPORTO_CONT_LORDO_TOT
        FROM
            CDP_DWH.WORK_PRONT_BP_SPEC WORK_PRONT_BP_SPEC
    ) WORK_PRONT_BP_SPEC_2,
    (
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP_SPEC) INDEX (WORK_PRONT_BP_SPEC W_PBS_IDX)  */
            WORK_PRONT_BP_SPEC.SERIE AS SERIE,
            WORK_PRONT_BP_SPEC.DATA_EMISSIONE AS DATA_EMISSIONE,
            WORK_PRONT_BP_SPEC.ANNI_MESI_INIZIO_ANZ AS ANNI_MESI_INIZIO_ANZ,
            WORK_PRONT_BP_SPEC.ANNI_MESI_FINE_ANZ AS ANNI_MESI_FINE_ANZ,
            WORK_PRONT_BP_SPEC.IMPORTO_LIQ_LORDO AS IMPORTO_LIQ_LORDO
        FROM
            CDP_DWH.WORK_PRONT_BP_SPEC WORK_PRONT_BP_SPEC
    ) WORK_PRONT_BP_SPEC_3
WHERE
    (
        TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH = WORK_PRONT_BP_SPEC_2.SERIE
        AND TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE = WORK_PRONT_BP_SPEC_2.DATA_EMISSIONE
        AND CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                CASE
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) < 780 THEN trunc(
                        months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                        ) / 12
                    ) || lpad(
                        trunc(
                            mod(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ),
                                12
                            )
                        ),
                        2,
                        '0'
                    )
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) >= 780 THEN TRUNC(
                        10.5 + (
                            0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                        )
                    ) + trunc(
                        LPAD(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 0.5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            2,
                            '0'
                        ) / 12
                    ) || LPAD(
                        mod(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            12
                        ),
                        2,
                        '0'
                    )
                END
            )
            ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BUONO
        END BETWEEN WORK_PRONT_BP_SPEC_2.ANNI_MESI_INIZIO_ANZ
        AND WORK_PRONT_BP_SPEC_2.ANNI_MESI_FINE_ANZ
        AND TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH = WORK_PRONT_BP_SPEC_1.SERIE
        AND TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE = WORK_PRONT_BP_SPEC_1.DATA_EMISSIONE
        AND CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                CASE
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) < 780 THEN trunc(
                        months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                        ) / 12
                    ) || lpad(
                        trunc(
                            mod(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ),
                                12
                            )
                        ),
                        2,
                        '0'
                    )
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) >= 780 THEN TRUNC(
                        10.5 + (
                            0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                        )
                    ) + trunc(
                        LPAD(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 0.5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            2,
                            '0'
                        ) / 12
                    ) || LPAD(
                        mod(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            12
                        ),
                        2,
                        '0'
                    )
                END
            )
            ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
        END BETWEEN WORK_PRONT_BP_SPEC_1.ANNI_MESI_INIZIO_ANZ
        AND WORK_PRONT_BP_SPEC_1.ANNI_MESI_FINE_ANZ
        AND TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH = WORK_PRONT_BP_SPEC_3.SERIE
        AND TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE = WORK_PRONT_BP_SPEC_3.DATA_EMISSIONE
        AND CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                CASE
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) < 780 THEN trunc(
                        months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                        ) / 12
                    ) || lpad(
                        trunc(
                            mod(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ),
                                12
                            )
                        ),
                        2,
                        '0'
                    )
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) >= 780 THEN TRUNC(
                        10.5 + (
                            0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                        )
                    ) + trunc(
                        LPAD(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 0.5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            2,
                            '0'
                        ) / 12
                    ) || LPAD(
                        mod(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            12
                        ),
                        2,
                        '0'
                    )
                END
            )
            ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BP_CAP
        END BETWEEN WORK_PRONT_BP_SPEC_3.ANNI_MESI_INIZIO_ANZ
        AND WORK_PRONT_BP_SPEC_3.ANNI_MESI_FINE_ANZ
    )
    AND (
        TMP_WORK_PRD_GIORNO_EXC.CODICE_SOTTOSISTEMA = 'BP'
        and TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH_1 is not null
    )
UNION
ALL
SELECT
    /*+  NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX)    NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX)    NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX)  */
    TMP_WORK_PRD_GIORNO_EXC.CODICE_SOTTOSISTEMA AS CODICE_SOTTOSISTEMA,
    TMP_WORK_PRD_GIORNO_EXC.PROVINCIA_EMISSIONE AS PROVINCIA_EMISSIONE,
    TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO AS CODICE_PRODOTTO,
    TMP_WORK_PRD_GIORNO_EXC.FIGURA_FISCALE AS FIGURA_FISCALE,
    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE AS DATA_EMISSIONE,
    TMP_WORK_PRD_GIORNO_EXC.DIVISA AS DIVISA,
    TMP_WORK_PRD_GIORNO_EXC.TAGLIO AS TAGLIO,
    (
        CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO LIKE 'BM%' THEN TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH
            ELSE TMP_WORK_PRD_GIORNO_EXC.SERIE
        END
    ) AS SERIE,
    TMP_WORK_PRD_GIORNO_EXC.REGIME_FISCALE AS REGIME_FISCALE,
    TMP_WORK_PRD_GIORNO_EXC.NUMERO_LIBRETTI AS NUMERO_LIBRETTI,
    TMP_WORK_PRD_GIORNO_EXC.CAPITALE AS CAPITALE,
    TMP_WORK_PRD_GIORNO_EXC.RATEO_INTERESSI AS RATEO_INTERESSI,
    TMP_WORK_PRD_GIORNO_EXC.PRV_ID AS PRV_ID,
    TMP_WORK_PRD_GIORNO_EXC.PRD_ID_1 AS PRD_ID_1,
    TMP_WORK_PRD_GIORNO_EXC.TGL_ID AS TGL_ID,
    TMP_WORK_PRD_GIORNO_EXC.TPS_COD AS TPS_COD,
    TMP_WORK_PRD_GIORNO_EXC.TPS_ID AS TPS_ID,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%' then case
                when TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK > add_months(
                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                    months_between(
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                    ) / 2
                ) + mod(
                    months_between(
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                    ) / 2,
                    1
                ) * 30 THEN 0
                else case
                    when to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'dd'
                    ) = '31'
                    or TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK = TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE then 0
                    else (
                        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                            round(
                                power(
                                    1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                                    substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                                ),
                                8
                            ) -1
                        ) * (
                            case
                                when to_char(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                    'MMDD'
                                ) = '0301' THEN case
                                    when to_char(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -1,
                                        'DD'
                                    ) = '29' then 2
                                    else 3
                                end
                                else 1
                            end
                        ) / (
                            (
                                trunc(
                                    months_between(
                                        add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    )
                                ) * 30 + (
                                    add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2
                                    ) + mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2,
                                        1
                                    ) * 30 - add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        months_between(
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        )
                                    )
                                ) - nvl(
                                    LENGTH(
                                        CASE
                                            WHEN TO_DATE(
                                                '3101' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3103' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3105' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3107' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3108' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30 THEN 1
                                            ELSE NULL
                                        END
                                    ),
                                    0
                                ) + CASE
                                    WHEN TO_DATE(
                                        '0103' || TO_CHAR(
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        months_between(
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        )
                                    ) + 1
                                    AND add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2
                                    ) + mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2,
                                        1
                                    ) * 30 THEN CASE
                                        WHEN TO_CHAR(
                                            TO_DATE(
                                                '0103' || TO_CHAR(
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) -1,
                                            'DD'
                                        ) = '28' THEN 2
                                        ELSE 1
                                    END
                                    ELSE 0
                                END
                            )
                        )
                    )
                end
            end
            else CASE
                WHEN CASE
                    WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN' THEN to_number(
                        CASE
                            WHEN months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                            ) < 780 THEN trunc(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ) / 12
                            ) || lpad(
                                trunc(
                                    mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        ),
                                        12
                                    )
                                ),
                                2,
                                '0'
                            )
                            WHEN months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                            ) >= 780 THEN TRUNC(
                                10.5 + (
                                    0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                                )
                            ) + trunc(
                                LPAD(
                                    CASE
                                        WHEN MOD(
                                            TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                            2
                                        ) = 0 THEN 0.5
                                        ELSE 0
                                    END + (
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                        ) - 780
                                    ),
                                    2,
                                    '0'
                                ) / 12
                            ) || LPAD(
                                mod(
                                    CASE
                                        WHEN MOD(
                                            TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                            2
                                        ) = 0 THEN 5
                                        ELSE 0
                                    END + (
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                        ) - 780
                                    ),
                                    12
                                ),
                                2,
                                '0'
                            )
                        END
                    )
                    ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
                END = 0 THEN 0
                ELSE CASE
                    WHEN TO_CHAR(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'MMDD'
                    ) = '0301'
                    and TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO not in ('BPFL', 'BPDL')
                    /*18mesi*/
                    THEN CASE
                        WHEN TO_CHAR(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -1,
                            'DD'
                        ) = '29' THEN (
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO * 2 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                        )
                        ELSE (
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO * 3 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                        )
                    END
                    ELSE CASE
                        WHEN TO_CHAR(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                            'MM'
                        ) = '02'
                        AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK = LAST_DAY(TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK)
                        and TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO in ('BPFL', 'BPDL')
                        /*18mesi*/
                        THEN CASE
                            WHEN TO_CHAR(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                'DD'
                            ) = '29' THEN (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO * 2 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                            ELSE (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO * 3 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        END
                        ELSE CASE
                            WHEN TO_CHAR(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                'DD'
                            ) = '31' THEN 0
                            ELSE (
                                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        END
                    END
                END
            end
        END
    ) AS INT_BP_CONT_GIORN,
    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK AS DATA_RIFERIMENTO_WORK,
    TMP_WORK_PRD_GIORNO_EXC.INTERESSE_MENSILE AS INTERESSE_MENSILE,
    (
        TMP_WORK_PRD_GIORNO_EXC.INTERESSE_TOTALE + case
            when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%' then case
                when TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK > add_months(
                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                    months_between(
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                    ) / 2
                ) + mod(
                    months_between(
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                    ) / 2,
                    1
                ) * 30 THEN 0
                else case
                    when to_char(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'dd'
                    ) = '31'
                    or TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK = TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE then 0
                    else TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        round(
                            power(
                                1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                                substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                            ),
                            8
                        ) -1
                    ) * (
                        case
                            when to_char(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                'MMDD'
                            ) = '0301' THEN case
                                when to_char(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -1,
                                    'DD'
                                ) = '29' then 2
                                else 3
                            end
                            else 1
                        end
                    ) / (
                        (
                            trunc(
                                months_between(
                                    add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2
                                    ) + mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2,
                                        1
                                    ) * 30,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                )
                            ) * 30 + (
                                add_months(
                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                    ) / 2
                                ) + mod(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                    ) / 2,
                                    1
                                ) * 30 - add_months(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                    months_between(
                                        add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    )
                                )
                            ) - nvl(
                                LENGTH(
                                    CASE
                                        WHEN TO_DATE(
                                            '3101' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3103' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3105' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3107' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3108' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3110' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3110' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ) -1,
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3112' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3112' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ) -1,
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30 THEN 1
                                        ELSE NULL
                                    END
                                ),
                                0
                            ) + CASE
                                WHEN TO_DATE(
                                    '0103' || TO_CHAR(
                                        add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30,
                                        'YYYY'
                                    ),
                                    'DDMMYYYY'
                                ) BETWEEN add_months(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                    months_between(
                                        add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    )
                                ) + 1
                                AND add_months(
                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                    ) / 2
                                ) + mod(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                    ) / 2,
                                    1
                                ) * 30 THEN CASE
                                    WHEN TO_CHAR(
                                        TO_DATE(
                                            '0103' || TO_CHAR(
                                                add_months(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2
                                                ) + mod(
                                                    months_between(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                    ) / 2,
                                                    1
                                                ) * 30,
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) -1,
                                        'DD'
                                    ) = '28' THEN 2
                                    ELSE 1
                                END
                                ELSE 0
                            END
                        )
                    )
                end
            end
            else CASE
                WHEN CASE
                    WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN' THEN to_number(
                        CASE
                            WHEN months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                            ) < 780 THEN trunc(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ) / 12
                            ) || lpad(
                                trunc(
                                    mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        ),
                                        12
                                    )
                                ),
                                2,
                                '0'
                            )
                            WHEN months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                            ) >= 780 THEN TRUNC(
                                10.5 + (
                                    0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                                )
                            ) + trunc(
                                LPAD(
                                    CASE
                                        WHEN MOD(
                                            TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                            2
                                        ) = 0 THEN 0.5
                                        ELSE 0
                                    END + (
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                        ) - 780
                                    ),
                                    2,
                                    '0'
                                ) / 12
                            ) || LPAD(
                                mod(
                                    CASE
                                        WHEN MOD(
                                            TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                            2
                                        ) = 0 THEN 5
                                        ELSE 0
                                    END + (
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                        ) - 780
                                    ),
                                    12
                                ),
                                2,
                                '0'
                            )
                        END
                    )
                    ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
                END = 0 THEN 0
                ELSE CASE
                    WHEN TO_CHAR(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                        'MMDD'
                    ) = '0301' THEN CASE
                        WHEN TO_CHAR(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -1,
                            'DD'
                        ) = '29' THEN (
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO * 2 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                        )
                        ELSE (
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO * 3 / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                        )
                    END
                    ELSE CASE
                        WHEN TO_CHAR(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                            'DD'
                        ) = '31' THEN 0
                        ELSE (
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO / TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                        )
                    END
                END
            END
        end
    ) AS INTERESSE_TOTALE,
    (
        CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO LIKE 'BM%' THEN TMP_WORK_PRD_GIORNO_EXC.SERIE
            ELSE TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH
        END
    ) AS SERIE_DWH,
    TMP_WORK_PRD_GIORNO_EXC.DVS_ID AS DVS_ID,
    TMP_WORK_PRD_GIORNO_EXC.COD_PROPRIETARIO AS COD_PROPRIETARIO,
    TMP_WORK_PRD_GIORNO_EXC.ID_PROPRIETARIO AS ID_PROPRIETARIO,
    TMP_WORK_PRD_GIORNO_EXC.FSC_ID AS FSC_ID,
    TMP_WORK_PRD_GIORNO_EXC.RGN_COD AS RGN_COD,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%' then case
                when TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK >= TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL then TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(
                    round(
                        power(
                            1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                            substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                        ),
                        8
                    ) -1
                )
                else (
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO
                ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
            end
            else (
                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO
            ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
        end
    ) AS INT_BP_LIQ_LORDI,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%' then case
                when TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK >= TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL then TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(
                    round(
                        power(
                            1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                            substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                        ),
                        8
                    ) -1
                ) *(1 - TMP_WORK_PRD_GIORNO_EXC.PRD_ALQ_REN)
                else (
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_NETTO
                ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
            end
            else (
                TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_NETTO
            ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
        end
    ) AS INT_BP_LIQ_NETTI,
    (
        CASE
            WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN'
            AND greatest(
                months_between(
                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                ) -780,
                0
            ) = 0 then (
                (
                    TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        1 + (
                            (
                                (
                                    (VW_ANAG_RIMBORSI_INT_BP_CONT.RIMBORSI_LORDI) - 1
                                ) /(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_SCADENZA_BP - TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                )
                            ) *(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK - TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                            )
                        )
                    )
                ) - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
            )
            WHEN nvl(META_SCTG_FASCE.SCTG_COD, 'BMIN') <> 'BMIN'
            AND greatest(
                months_between(
                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                ) -780,
                0
            ) != 0 then TMP_WORK_PRD_GIORNO_EXC.CAPITALE * VW_ANAG_RIMBORSI_INT_BP_CONT.RIMBORSI_LORDI
            else CASE
                WHEN TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO LIKE 'BM%' THEN case
                    when TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK > (
                        add_months(
                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                            months_between(
                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                            ) / 2
                        ) + mod(
                            months_between(
                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                            ) / 2,
                            1
                        ) * 30
                    )
                    /* SCADENZA_BM */
                    THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(
                        round(
                            power(
                                1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                                substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                            ),
                            8
                        ) -1
                    )
                    else (
                        (
                            TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                                round(
                                    power(
                                        1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                                        substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                                    ),
                                    8
                                ) -1
                            ) * (
                                trunc(
                                    MONTHS_BETWEEN(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    )
                                ) * 30 + (
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK - ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        MONTHS_BETWEEN(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        )
                                    )
                                ) - nvl(
                                    LENGTH(
                                        CASE
                                            WHEN TO_DATE(
                                                '3101' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3103' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3105' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3107' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3108' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END
                                    ),
                                    0
                                ) + CASE
                                    WHEN TO_DATE(
                                        '0103' || TO_CHAR(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN CASE
                                        WHEN TO_CHAR(
                                            TO_DATE(
                                                '0103' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) -1,
                                            'DD'
                                        ) = '28' THEN 2
                                        ELSE 1
                                    END
                                    ELSE 0
                                END
                            )
                        )
                    ) / (
                        (
                            trunc(
                                months_between(
                                    (
                                        add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2
                                        ) + mod(
                                            months_between(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                            ) / 2,
                                            1
                                        ) * 30
                                    ),
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                )
                            ) * 30 + (
                                (
                                    add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2
                                    ) + mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2,
                                        1
                                    ) * 30
                                ) - add_months(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                    months_between(
                                        (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ),
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    )
                                )
                            ) - nvl(
                                LENGTH(
                                    CASE
                                        WHEN TO_DATE(
                                            '3101' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3103' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3105' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3107' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3108' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3110' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3110' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ) -1,
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3112' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END || CASE
                                        WHEN TO_DATE(
                                            '3112' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ) -1,
                                            'DDMMYYYY'
                                        ) BETWEEN add_months(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                            months_between(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                            )
                                        ) + 1
                                        AND (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ) THEN 1
                                        ELSE NULL
                                    END
                                ),
                                0
                            ) + CASE
                                WHEN TO_DATE(
                                    '0103' || TO_CHAR(
                                        (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ),
                                        'YYYY'
                                    ),
                                    'DDMMYYYY'
                                ) BETWEEN add_months(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                    months_between(
                                        (
                                            add_months(
                                                TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2
                                            ) + mod(
                                                months_between(
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                    TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                ) / 2,
                                                1
                                            ) * 30
                                        ),
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    )
                                ) + 1
                                AND (
                                    add_months(
                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2
                                    ) + mod(
                                        months_between(
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                        ) / 2,
                                        1
                                    ) * 30
                                ) THEN CASE
                                    WHEN TO_CHAR(
                                        TO_DATE(
                                            '0103' || TO_CHAR(
                                                (
                                                    add_months(
                                                        TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL,
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2
                                                    ) + mod(
                                                        months_between(
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_AL + 1,
                                                            TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL
                                                        ) / 2,
                                                        1
                                                    ) * 30
                                                ),
                                                'YYYY'
                                            ),
                                            'DDMMYYYY'
                                        ) -1,
                                        'DD'
                                    ) = '28' THEN 2
                                    ELSE 1
                                END
                                ELSE 0
                            END
                        )
                    )
                end
                else CASE
                    WHEN TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO = 0 THEN CASE
                        WHEN TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BUONO = 0 THEN 0
                        ELSE TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                    END
                    ELSE CASE
                        WHEN TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                            ADD_MONTHS(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                SUBSTR(
                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                    1,
                                    2
                                ) * 12 + SUBSTR(
                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                    -2
                                )
                            )
                        ) = 0 THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                        ELSE
                        /*interesse bimestre concluso + interesse bimestre parziale in corso*/
                        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_CONT_LORDO_TOT - TMP_WORK_PRD_GIORNO_EXC.CAPITALE + (
                            (
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                                    ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            1,
                                            2
                                        ) * 12 + SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            -2
                                        )
                                    )
                                ) - nvl(
                                    LENGTH(
                                        CASE
                                            WHEN TO_DATE(
                                                '3101' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3103' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3105' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3107' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3108' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END
                                    ),
                                    0
                                ) + CASE
                                    WHEN TO_DATE(
                                        '0103' || TO_CHAR(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            1,
                                            2
                                        ) * 12 + SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            -2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN CASE
                                        WHEN TO_CHAR(
                                            TO_DATE(
                                                '0103' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) -1,
                                            'DD'
                                        ) = '28' THEN 2
                                        ELSE 1
                                    END
                                    ELSE 0
                                END
                            ) * TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_1.IMPORTO_CONT_LORDO / decode(
                                ADD_MONTHS(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                    SUBSTR(
                                        LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                        1,
                                        2
                                    ) * 12 + SUBSTR(
                                        LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                        -2
                                    )
                                ),
                                last_day(
                                    to_date(
                                        '0102' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'yyyy'
                                        ),
                                        'ddmmyyyy'
                                    )
                                ),
                                TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP + least(
                                    2,
                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') - to_char(
                                        last_day(
                                            to_date(
                                                '0102' || to_char(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'yyyy'
                                                ),
                                                'ddmmyyyy'
                                            )
                                        ),
                                        'dd'
                                    )
                                ),
                                TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        )
                    end
                end
            END
        end
    ) AS INT_BP_CONT_SP,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_VT_PR = 1 then case
                when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%'
                and TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL -1 <= TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK then TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                    round(
                        power(
                            1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                            substr(TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO, -3) / 6
                        ),
                        8
                    ) -1
                )
                else TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(WORK_PRONT_BP_3.IMPORTO_LIQ_LORDO -1)
            end
            else 0
        end
    ) AS INT_BP_CAP,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_VT_PR = 0 then 0
            else case
                when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%' then case
                    when TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL -1 <= TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK then TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                        round(
                            power(
                                1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                                substr(TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO, -3) / 6
                            ),
                            8
                        ) -1
                    )
                    else TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                end
                else CASE
                    WHEN TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO = 0 THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                    ELSE CASE
                        WHEN TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                            ADD_MONTHS(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                SUBSTR(
                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                    1,
                                    2
                                ) * 12 + SUBSTR(
                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                    -2
                                )
                            )
                        ) = 0 THEN TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE
                        ELSE
                        /*interesse bimestre concluso + interesse bimestre parziale in corso*/
                        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO - TMP_WORK_PRD_GIORNO_EXC.CAPITALE + (
                            (
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK -(
                                    ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            1,
                                            2
                                        ) * 12 + SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            -2
                                        )
                                    )
                                ) - nvl(
                                    LENGTH(
                                        CASE
                                            WHEN TO_DATE(
                                                '3101' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3103' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3105' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3107' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3108' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3110' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END || CASE
                                            WHEN TO_DATE(
                                                '3112' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ) -1,
                                                'DDMMYYYY'
                                            ) BETWEEN ADD_MONTHS(
                                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                                SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    1,
                                                    2
                                                ) * 12 + SUBSTR(
                                                    LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                                    -2
                                                )
                                            ) + 1
                                            AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN 1
                                            ELSE NULL
                                        END
                                    ),
                                    0
                                ) + CASE
                                    WHEN TO_DATE(
                                        '0103' || TO_CHAR(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'YYYY'
                                        ),
                                        'DDMMYYYY'
                                    ) BETWEEN ADD_MONTHS(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                        SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            1,
                                            2
                                        ) * 12 + SUBSTR(
                                            LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                            -2
                                        )
                                    ) + 1
                                    AND TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK THEN CASE
                                        WHEN TO_CHAR(
                                            TO_DATE(
                                                '0103' || TO_CHAR(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'YYYY'
                                                ),
                                                'DDMMYYYY'
                                            ) -1,
                                            'DD'
                                        ) = '28' THEN 2
                                        ELSE 1
                                    END
                                    ELSE 0
                                END
                            ) * TMP_WORK_PRD_GIORNO_EXC.CAPITALE * (
                                WORK_PRONT_BP_1.IMPORTO_LIQ_LORDO - WORK_PRONT_BP_2.IMPORTO_LIQ_LORDO
                            ) / decode(
                                ADD_MONTHS(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE,
                                    SUBSTR(
                                        LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                        1,
                                        2
                                    ) * 12 + SUBSTR(
                                        LPAD(WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ, 4, '0'),
                                        -2
                                    )
                                ),
                                last_day(
                                    to_date(
                                        '0102' || to_char(
                                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                            'yyyy'
                                        ),
                                        'ddmmyyyy'
                                    )
                                ),
                                TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP + least(
                                    2,
                                    to_char(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'dd') - to_char(
                                        last_day(
                                            to_date(
                                                '0102' || to_char(
                                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                                                    'yyyy'
                                                ),
                                                'ddmmyyyy'
                                            )
                                        ),
                                        'dd'
                                    )
                                ),
                                TMP_WORK_PRD_GIORNO_EXC.PRD_INTERV_CAP
                            )
                        )
                    end
                end
            END
        end
    ) AS INT_LIQ_LORDI_GG,
    (
        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * nvl(XPREMIO_TOT.PREMIO_TOT, 0)
    ) AS CAPITALE_PREMIO_TOT,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%'
            and TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK >= TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL then TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(
                round(
                    power(
                        1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                        substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                    ),
                    8
                ) -1
            )
            else TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(WORK_PRONT_BP_2.IMPORTO_LIQ_BASE_LORDO -1)
        end
    ) AS INT_LIQ_BASE_LORDI,
    (
        case
            when TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO like 'BM%'
            and TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK >= TMP_WORK_PRD_GIORNO_EXC.PRD_SCADENZA_DAL then TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(
                round(
                    power(
                        1 + TMP_WORK_PRD_GIORNO_EXC.PRD_TASSO_INTERESSE,
                        substr(TMP_WORK_PRD_GIORNO_EXC.SERIE, -3) / 6
                    ),
                    8
                ) -1
            ) *(1 - TMP_WORK_PRD_GIORNO_EXC.PRD_ALQ_REN)
            else TMP_WORK_PRD_GIORNO_EXC.CAPITALE *(WORK_PRONT_BP_2.IMPORT_LIQ_BASE_NETTO -1)
        end
    ) AS INT_LIQ_BASE_NETTI,
    (
        TMP_WORK_PRD_GIORNO_EXC.CAPITALE * nvl(WORK_BP_IND_PREMIO.VALORE_PREMIO, 0)
    ) AS CAPITALE_PREMIO_OPZ,
    TMP_WORK_PRD_GIORNO_EXC.CAPITALE_NOMINALE AS CAPITALE_NOMINALE,
    TMP_WORK_PRD_GIORNO_EXC.DATA_SCADENZA_BP AS DATA_SCADENZA_BP,
    TMP_WORK_PRD_GIORNO_EXC.GIACENZA AS GIACENZA,
    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA AS DATA_NASCITA,
    TMP_WORK_PRD_GIORNO_EXC.ID_CANALE_VENDITA AS ID_CANALE_VENDITA
FROM
    (
        CDP_DWH.TMP_WORK_PRD_GIORNO_EXC TMP_WORK_PRD_GIORNO_EXC
        INNER JOIN CDP_ANAG.META_SCTG_FASCE @LCDP_ANAG META_SCTG_FASCE ON TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = META_SCTG_FASCE.SCTG_COD
    ),
    CDP_DWH.WORK_BP_IND_PREMIO WORK_BP_IND_PREMIO,
    (
        SELECT
            DISTINCT (SUM(WORK_BP_IND_PREMIO_1.VALORE_PREMIO)) AS PREMIO_TOT,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE AS MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.ANNI_MESI_ANZIANITA AS ANNI_MESI_ANZIANITA,
            WORK_BP_IND_PREMIO_2.PRD_COD AS PRD_COD,
            nvl(
                lead(WORK_BP_IND_PREMIO_2.ANNI_MESI_ANZIANITA, 1) over (
                    partition by WORK_BP_IND_PREMIO_2.PRD_COD,
                    WORK_BP_IND_PREMIO_2.MESE_EMISSIONE
                    order by
                        WORK_BP_IND_PREMIO_2.ANNI_MESI_ANZIANITA
                ),
                '9999'
            ) AS ANNI_MESI_ANZ_SUCC
        FROM
            (
                SELECT
                    WORK_BP_IND_PREMIO.PRD_COD AS PRD_COD,
                    WORK_BP_IND_PREMIO.ANNI_MESI_ANZIANITA AS ANNI_MESI_ANZIANITA,
                    WORK_BP_IND_PREMIO.VALORE_PREMIO AS VALORE_PREMIO,
                    WORK_BP_IND_PREMIO.MESE_EMISSIONE AS MESE_EMISSIONE
                FROM
                    CDP_DWH.WORK_BP_IND_PREMIO WORK_BP_IND_PREMIO
            ) WORK_BP_IND_PREMIO_1,
            (
                SELECT
                    WORK_BP_IND_PREMIO.PRD_COD AS PRD_COD,
                    WORK_BP_IND_PREMIO.ANNI_MESI_ANZIANITA AS ANNI_MESI_ANZIANITA,
                    WORK_BP_IND_PREMIO.VALORE_PREMIO AS VALORE_PREMIO,
                    WORK_BP_IND_PREMIO.MESE_EMISSIONE AS MESE_EMISSIONE
                FROM
                    CDP_DWH.WORK_BP_IND_PREMIO WORK_BP_IND_PREMIO
            ) WORK_BP_IND_PREMIO_2
        WHERE
            (
                WORK_BP_IND_PREMIO_2.PRD_COD = WORK_BP_IND_PREMIO_1.PRD_COD
                and WORK_BP_IND_PREMIO_2.MESE_EMISSIONE = WORK_BP_IND_PREMIO_1.MESE_EMISSIONE
                and WORK_BP_IND_PREMIO_2.ANNI_MESI_ANZIANITA >= WORK_BP_IND_PREMIO_1.ANNI_MESI_ANZIANITA
            )
        GROUP BY
            WORK_BP_IND_PREMIO_2.PRD_COD,
            WORK_BP_IND_PREMIO_2.ANNI_MESI_ANZIANITA,
            WORK_BP_IND_PREMIO_2.VALORE_PREMIO,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE,
            WORK_BP_IND_PREMIO_2.MESE_EMISSIONE
    ) XPREMIO_TOT,
    (
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX)  */
            WORK_PRONT_BP.SERIE AS SERIE,
            WORK_PRONT_BP.ANNI_MESI_INIZIO_ANZ AS ANNI_MESI_INIZIO_ANZ,
            WORK_PRONT_BP.ANNI_MESI_FINE_ANZ AS ANNI_MESI_FINE_ANZ,
            WORK_PRONT_BP.IMPORTO_LIQ_LORDO AS IMPORTO_LIQ_LORDO,
            WORK_PRONT_BP.IMPORTO_CONT_LORDO AS IMPORTO_CONT_LORDO,
            WORK_PRONT_BP.DATA_DECORRENZA AS DATA_DECORRENZA,
            WORK_PRONT_BP.DATA_FINE_DECORRENZA AS DATA_FINE_DECORRENZA,
            WORK_PRONT_BP.MESE_EMISSIONE AS MESE_EMISSIONE
        FROM
            CDP_DWH.WORK_PRONT_BP WORK_PRONT_BP
    ) WORK_PRONT_BP_1,
    (
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX)  */
            WORK_PRONT_BP.SERIE AS SERIE,
            WORK_PRONT_BP.ANNI_MESI_INIZIO_ANZ AS ANNI_MESI_INIZIO_ANZ,
            WORK_PRONT_BP.ANNI_MESI_FINE_ANZ AS ANNI_MESI_FINE_ANZ,
            WORK_PRONT_BP.IMPORTO_LIQ_LORDO AS IMPORTO_LIQ_LORDO,
            WORK_PRONT_BP.IMPORTO_LIQ_NETTO AS IMPORTO_LIQ_NETTO,
            WORK_PRONT_BP.IMPORTO_CONT_LORDO_TOT AS IMPORTO_CONT_LORDO_TOT,
            WORK_PRONT_BP.DATA_DECORRENZA AS DATA_DECORRENZA,
            WORK_PRONT_BP.DATA_FINE_DECORRENZA AS DATA_FINE_DECORRENZA,
            WORK_PRONT_BP.IMPORTO_LIQ_BASE_LORDO AS IMPORTO_LIQ_BASE_LORDO,
            WORK_PRONT_BP.IMPORTO_LIQ_BASE_NETTO AS IMPORT_LIQ_BASE_NETTO,
            WORK_PRONT_BP.MESE_EMISSIONE AS MESE_EMISSIONE
        FROM
            CDP_DWH.WORK_PRONT_BP WORK_PRONT_BP
    ) WORK_PRONT_BP_2,
    (
        SELECT
            /*+  NOPARALLEL (WORK_PRONT_BP) INDEX (WORK_PRONT_BP W_PB_IDX)  */
            WORK_PRONT_BP.SERIE AS SERIE,
            WORK_PRONT_BP.ANNI_MESI_INIZIO_ANZ AS ANNI_MESI_INIZIO_ANZ,
            WORK_PRONT_BP.ANNI_MESI_FINE_ANZ AS ANNI_MESI_FINE_ANZ,
            WORK_PRONT_BP.IMPORTO_LIQ_LORDO AS IMPORTO_LIQ_LORDO,
            WORK_PRONT_BP.DATA_DECORRENZA AS DATA_DECORRENZA,
            WORK_PRONT_BP.DATA_FINE_DECORRENZA AS DATA_FINE_DECORRENZA,
            WORK_PRONT_BP.MESE_EMISSIONE AS MESE_EMISSIONE
        FROM
            CDP_DWH.WORK_PRONT_BP WORK_PRONT_BP
    ) WORK_PRONT_BP_3,
    CDP_DWH.VW_ANAG_RIMBORSI_INT_BP_CONT VW_ANAG_RIMBORSI_INT_BP_CONT
WHERE
    (
        TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH = WORK_PRONT_BP_2.SERIE
        and CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                CASE
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) < 780 THEN trunc(
                        months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                        ) / 12
                    ) || lpad(
                        trunc(
                            mod(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ),
                                12
                            )
                        ),
                        2,
                        '0'
                    )
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) >= 780 THEN TRUNC(
                        10.5 + (
                            0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                        )
                    ) + trunc(
                        LPAD(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 0.5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            2,
                            '0'
                        ) / 12
                    ) || LPAD(
                        mod(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            12
                        ),
                        2,
                        '0'
                    )
                END
            )
            ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BUONO
        END between WORK_PRONT_BP_2.ANNI_MESI_INIZIO_ANZ
        and WORK_PRONT_BP_2.ANNI_MESI_FINE_ANZ
        and trunc(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'mm') = WORK_PRONT_BP_2.MESE_EMISSIONE
        and TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK between WORK_PRONT_BP_2.DATA_DECORRENZA
        and WORK_PRONT_BP_2.DATA_FINE_DECORRENZA
        AND TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH = WORK_PRONT_BP_1.SERIE
        AND CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                CASE
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) < 780 THEN trunc(
                        months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                        ) / 12
                    ) || lpad(
                        trunc(
                            mod(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ),
                                12
                            )
                        ),
                        2,
                        '0'
                    )
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) >= 780 THEN TRUNC(
                        10.5 + (
                            0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                        )
                    ) + trunc(
                        LPAD(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 0.5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            2,
                            '0'
                        ) / 12
                    ) || LPAD(
                        mod(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            12
                        ),
                        2,
                        '0'
                    )
                END
            )
            ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_CONT_BUONO
        END between WORK_PRONT_BP_1.ANNI_MESI_INIZIO_ANZ
        and WORK_PRONT_BP_1.ANNI_MESI_FINE_ANZ
        and trunc(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'mm') = WORK_PRONT_BP_1.MESE_EMISSIONE
        and TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK between WORK_PRONT_BP_1.DATA_DECORRENZA
        and WORK_PRONT_BP_1.DATA_FINE_DECORRENZA
        AND TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH = WORK_PRONT_BP_3.SERIE
        AND CASE
            WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                CASE
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) < 780 THEN trunc(
                        months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                        ) / 12
                    ) || lpad(
                        trunc(
                            mod(
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                ),
                                12
                            )
                        ),
                        2,
                        '0'
                    )
                    WHEN months_between(
                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                    ) >= 780 THEN TRUNC(
                        10.5 + (
                            0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                        )
                    ) + trunc(
                        LPAD(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 0.5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            2,
                            '0'
                        ) / 12
                    ) || LPAD(
                        mod(
                            CASE
                                WHEN MOD(
                                    TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                    2
                                ) = 0 THEN 5
                                ELSE 0
                            END + (
                                months_between(
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                    TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                ) - 780
                            ),
                            12
                        ),
                        2,
                        '0'
                    )
                END
            )
            ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BP_CAP
        END between WORK_PRONT_BP_3.ANNI_MESI_INIZIO_ANZ
        and WORK_PRONT_BP_3.ANNI_MESI_FINE_ANZ
        and trunc(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'mm') = WORK_PRONT_BP_3.MESE_EMISSIONE
        and TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK between WORK_PRONT_BP_3.DATA_DECORRENZA
        and WORK_PRONT_BP_3.DATA_FINE_DECORRENZA
        and XPREMIO_TOT.PRD_COD (+) = TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH
        and XPREMIO_TOT.MESE_EMISSIONE (+) = trunc(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'mm')
        and lpad(
            CASE
                WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                    CASE
                        WHEN months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                        ) < 780 THEN trunc(
                            months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                            ) / 12
                        ) || lpad(
                            trunc(
                                mod(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    ),
                                    12
                                )
                            ),
                            2,
                            '0'
                        )
                        WHEN months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                        ) >= 780 THEN TRUNC(
                            10.5 + (
                                0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                            )
                        ) + trunc(
                            LPAD(
                                CASE
                                    WHEN MOD(
                                        TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                        2
                                    ) = 0 THEN 0.5
                                    ELSE 0
                                END + (
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                    ) - 780
                                ),
                                2,
                                '0'
                            ) / 12
                        ) || LPAD(
                            mod(
                                CASE
                                    WHEN MOD(
                                        TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                        2
                                    ) = 0 THEN 5
                                    ELSE 0
                                END + (
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                    ) - 780
                                ),
                                12
                            ),
                            2,
                            '0'
                        )
                    END
                )
                ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BUONO
            END,
            4,
            '0'
        ) >= XPREMIO_TOT.ANNI_MESI_ANZIANITA (+)
        and lpad(
            CASE
                WHEN TMP_WORK_PRD_GIORNO_EXC.SCTG_COD = 'BS65' THEN to_number(
                    CASE
                        WHEN months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                        ) < 780 THEN trunc(
                            months_between(
                                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                            ) / 12
                        ) || lpad(
                            trunc(
                                mod(
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE
                                    ),
                                    12
                                )
                            ),
                            2,
                            '0'
                        )
                        WHEN months_between(
                            TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                            TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                        ) >= 780 THEN TRUNC(
                            10.5 + (
                                0.5 * TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2))
                            )
                        ) + trunc(
                            LPAD(
                                CASE
                                    WHEN MOD(
                                        TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                        2
                                    ) = 0 THEN 0.5
                                    ELSE 0
                                END + (
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                    ) - 780
                                ),
                                2,
                                '0'
                            ) / 12
                        ) || LPAD(
                            mod(
                                CASE
                                    WHEN MOD(
                                        TO_NUMBER(SUBSTR(TMP_WORK_PRD_GIORNO_EXC.SERIE, -2)),
                                        2
                                    ) = 0 THEN 5
                                    ELSE 0
                                END + (
                                    months_between(
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_EXC,
                                        TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
                                    ) - 780
                                ),
                                12
                            ),
                            2,
                            '0'
                        )
                    END
                )
                ELSE TMP_WORK_PRD_GIORNO_EXC.ANZIANITA_BUONO
            END,
            4,
            '0'
        ) < XPREMIO_TOT.ANNI_MESI_ANZ_SUCC (+)
        and WORK_BP_IND_PREMIO.PRD_COD (+) = TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH
        and WORK_BP_IND_PREMIO.MESE_EMISSIONE (+) = trunc(TMP_WORK_PRD_GIORNO_EXC.DATA_EMISSIONE, 'mm')
        and WORK_BP_IND_PREMIO.ANNI_MESI_ANZIANITA (+) || '00' = TMP_WORK_PRD_GIORNO_EXC.ANZ_BP_PREMIO_OPZ
        and TMP_WORK_PRD_GIORNO_EXC.SERIE = VW_ANAG_RIMBORSI_INT_BP_CONT.COD_SERIE (+)
        and greatest(
            months_between(
                TMP_WORK_PRD_GIORNO_EXC.DATA_RIFERIMENTO_WORK,
                TMP_WORK_PRD_GIORNO_EXC.DATA_NASCITA
            ) -780,
            0
        ) = VW_ANAG_RIMBORSI_INT_BP_CONT.RATA (+)
        and substr(
            TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO,
            length(TMP_WORK_PRD_GIORNO_EXC.CODICE_PRODOTTO) -1,
            2
        ) = lpad(VW_ANAG_RIMBORSI_INT_BP_CONT.FASCIA (+), 2, 0)
    )
    AND (
        TMP_WORK_PRD_GIORNO_EXC.CODICE_SOTTOSISTEMA = 'BP'
        and TMP_WORK_PRD_GIORNO_EXC.SERIE_DWH_1 is null
    )
) UNION_FINALE
where
    (1 = 1)
