/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").
 * You may not use this file except in compliance with the License.
 *
 * You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at usr/src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#pragma ident	"@(#)tst.strtok.d	1.1	06/08/28 SMI"

#pragma D option quiet
#pragma D option statusrate=10ms

BEGIN
{
	this->str = ",,,Carrots,,Barley,Oatmeal,,,Beans,";
}

BEGIN
/(this->field = strtok(this->str, ",")) == NULL/
{
	exit(1);
}

BEGIN
{
	printf("%s\n", this->field);
}

BEGIN
/(this->field = strtok(NULL, ",")) == NULL/
{
	exit(2);
}

BEGIN
{
	printf("%s\n", this->field);
}

BEGIN
/(this->field = strtok(NULL, ",")) == NULL/
{
	exit(3);
}

BEGIN
{
	printf("%s\n", this->field);
}

BEGIN
/(this->field = strtok(NULL, ",")) == NULL/
{
	exit(4);
}

BEGIN
{
	printf("%s\n", this->field);
}

BEGIN
/(self->a = strtok(NULL, ",")) != NULL/
{
	printf("unexpected field: %s\n", this->field);
	exit(5);
}

struct {
	string s1;
	string s2;
	string result;
} command[int];

int i;

BEGIN
{
	command[i].s1 = "";
	command[i].s2 = "";
	command[i].result = "";
	i++;

	command[i].s1 = "foo";
	command[i].s2 = "";
	command[i].result = command[i].s1;
	i++;

	command[i].s1 = "foobar";
	command[i].s2 = "o";
	command[i].result = "f";
	i++;

	command[i].s1 = "oobar";
	command[i].s2 = "o";
	command[i].result = "bar";
	i++;

	command[i].s1 = "foo";
	command[i].s2 = "bar";
	command[i].result = command[i].s1;
	i++;

	command[i].s1 = "";
	command[i].s2 = "foo";
	command[i].result = "";
	i++;

	end = i;
	i = 0;
}

profile-10ms
/i < end &&
    (this->result = strtok(command[i].s1, command[i].s2)) != command[i].result && cpu == 0/
{
	printf("strtok(\"%s\", \"%s\") = \"%s\", expected \"%s\"",
	    command[i].s1, command[i].s2,
	    this->result != NULL ? this->result : "<null>",
	    command[i].result != NULL ? command[i].result : "<null>");
	exit(6 + i);
}

profile-10ms
/ cpu == 0 /
{
	i++;
}

profile-10ms
/i == end && cpu == 0/
{
	exit(0);
}
