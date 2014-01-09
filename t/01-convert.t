use strict;
use warnings;
use Test::More;
plan tests => 2 + blocks();
use Test::NoWarnings;
use Convert::TBX::Min 'min2basic';
use Test::Base;
use Test::XML;
use Test::LongString;

sub convert {
    my $min = TBX::Min->new_from_xml(\$_);
    return ${min2basic($min)};
}
filters {input => 'convert'};

for my $block(blocks){
    is_xml($block->input, $block->expected, $block->name);
}

# separately test that the output has the doctype required by the TBX
# Checker. This is not tested by is_xml.
like_string( (blocks)[0]->input,
    qr/<!DOCTYPE martif SYSTEM "TBXBasiccoreStructV02.dtd">/,
    'output contains doctype');

__DATA__
=== basic
--- input
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== subjectField
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <subjectField>whatever</subjectField>
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
            <descrip type="subjectField">whatever</descrip>
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== full header
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
        <description>A short sample file demonstrating TBX-Min</description>
        <dateCreated>2013-11-12T00:00:00</dateCreated>
        <creator>Klaus-Dirk Schmidt</creator>
        <directionality>bidirectional</directionality>
        <license>CC BY license can be freely copied and modified</license>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>license: CC BY license can be freely copied and modified</p>
                <p>directionality: bidirectional</p>
                <p>description: A short sample file demonstrating TBX-Min</p>
                <p>creator: Klaus-Dirk Schmidt</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
            <p type="XCSURI">TBXBasicXCSV02.xcs</p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== multiple conceptEntries
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog1</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
        <conceptEntry id="C003">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog2</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog1</term>
                    </tig>
                </langSet>
            </termEntry>
            <termEntry id="C003">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog2</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== multiple langGroups
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
            <langGroup xml:lang="de">
                <termGroup>
                    <term>hund</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="de">
                    <tig>
                        <term>hund</term>
                    </tig>
                </langSet>
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== full termGroup
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <note>cute!</note>
                    <termStatus>preferred</termStatus>
                    <customer>SAP</customer>
                    <partOfSpeech>noun</partOfSpeech>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                <tig>
                  <admin>cute!</admin>
                  <termNote type="partOfSpeech">noun</termNote>
                  <admin type="customerSubset">SAP</admin>
                  <termNote type="administrativeStatus">preferred</termNote>
                  <term>dog</term>
                </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>
