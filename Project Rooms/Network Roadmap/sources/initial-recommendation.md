# Initial Network Modernization Recommendation

## User Direction

Create a Project Room that implements the network-modernization suggestions discussed while moving OfficeAssist workflows between workgroup computers. The final room name is `Network Roadmap`.

## Current Facts

- The environment uses multiple Windows workgroup computers rather than a Windows domain.
- The authoritative Project Room messaging queue is currently hosted on `WES-VIDEOEDITOR` at `\\WES-VIDEOEDITOR\BYH-PRMessaging$`.
- OfficeAssist has experienced SMB credential and identity-context friction when accessing that queue.
- OfficeAssist now runs production Email Monitor and Doc Scan workflows.
- The current WesStudio identity check reported no Azure AD, enterprise, domain, or workplace join. Other machine details remain to be verified from each machine.

## Recommendation

1. Do not deploy traditional on-premises Active Directory solely to eliminate the current workgroup credential friction.
2. First verify Microsoft 365 licensing, Windows editions, device ownership, and workflow dependencies.
3. Pilot Microsoft Entra ID join and Intune on one noncritical Windows Pro device.
4. Define rollback and acceptance criteria before enrollment.
5. Roll out production computers in stages only after a successful pilot.
6. Treat Project Room messaging transport as a separate architecture decision. Compare hardened SMB, a managed server or NAS, and a cloud-native queue before moving the authoritative queue.

## Primary Microsoft References

- [Microsoft Entra join](https://learn.microsoft.com/en-us/entra/identity/devices/concept-directory-join)
- [Windows enrollment in Intune](https://learn.microsoft.com/en-us/intune/device-enrollment/windows/guide)
- [Microsoft 365 Business Premium security FAQ](https://learn.microsoft.com/en-us/microsoft-365/admin/security-and-compliance/m365bp-security-faq)
- [Group Policy overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview)
- [Microsoft Entra hybrid join](https://learn.microsoft.com/en-us/entra/identity/devices/concept-hybrid-join)

