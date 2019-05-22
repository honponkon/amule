FUNCTION (CHECK_MANPAGE BINARY)
	FILE (GLOB MAN_PAGE_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*.1")

	FOREACH (MAN_PAGE ${MAN_PAGE_FILES})
		STRING (REGEX REPLACE "\\." ";" MAN_PAGE ${MAN_PAGE})
		LIST (LENGTH MAN_PAGE LENGTH)
		LIST (GET MAN_PAGE 0 NAME)

		IF (NAME STREQUAL ${BINARY})
			IF (LENGTH EQUAL 2)
				INSTALL (FILES "${NAME}.1"
					DESTINATION "${CMAKE_INSTALL_MANDIR}/man1"
				)
			ELSE (LENGTH EQUAL 2)
				IF (ENABLE_NLS)
					LIST (GET MAN_PAGE 1 LANG)

					IF (${TRANSLATION_${LANG}})
						INSTALL (FILES "${NAME}.${LANG}.1"
							DESTINATION "${CMAKE_INSTALL_MANDIR}/${LANG}/man1"
							RENAME "${NAME}.1"
						)
					ENDIF (${TRANSLATION_${LANG}})
				ENDIF (ENABLE_NLS)
			ENDIF (LENGTH EQUAL 2)
		ENDIF (NAME STREQUAL ${BINARY})
	ENDFOREACH (MAN_PAGE ${MAN_PAGE_FILES})
ENDFUNCTION (CHECK_MANPAGE BINARY)
